package com.example.xverifydemoapp

import android.app.PendingIntent
import android.content.Intent
import android.graphics.BitmapFactory
import android.nfc.NfcAdapter
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import com.example.xverifydemoapp.extentions.getResultVerifyEid
import com.example.xverifydemoapp.extentions.toMap
import com.example.xverifydemoapp.models.PreviewDocumentModel
import com.example.xverifydemoapp.models.RepresentativeModel
import com.example.xverifydemoapp.models.VerifyTaxCode
import com.example.xverifydemoapp.platforms.CameraLivenessFactory
import com.example.xverifydemoapp.platforms.CameraMrzFactory
import com.example.xverifydemoapp.platforms.CameraQrFactory
import com.example.xverifydemoapp.utils.ApiConfig
import com.example.xverifydemoapp.utils.BusinessType
import com.example.xverifydemoapp.utils.ChannelCallback
import com.example.xverifydemoapp.utils.FlutterChannelConstant
import com.example.xverifydemoapp.utils.ONBOARDDATAMANAGER
import com.example.xverifydemoapp.utils.PreferencesKeys
import com.example.xverifydemoapp.utils.PreferencesKeys.KEY_ID_CARD
import com.example.xverifydemoapp.utils.PreferencesKeys.KEY_SHARE_NAME
import com.example.xverifydemoapp.utils.Utils
import com.example.xverifydemoapp.views.NfcFragment
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugins.GeneratedPluginRegistrant
import io.reactivex.disposables.CompositeDisposable
import net.sf.scuba.data.Gender
import org.jmrtd.lds.icao.MRZInfo
import org.json.JSONObject
import vn.jth.xverifysdk.card.EidFacade
import vn.jth.xverifysdk.card.MRZCallback
import vn.jth.xverifysdk.card.MRZException
import vn.jth.xverifysdk.data.BasicInformation
import vn.jth.xverifysdk.data.DocumentType
import vn.jth.xverifysdk.network.ApiService
import vn.jth.xverifysdk.network.ApiService.Companion.APISERVICE
import vn.jth.xverifysdk.network.BioApiService
import vn.jth.xverifysdk.network.BioApiService.BIOAPISERVICE
import vn.jth.xverifysdk.network.models.RestCallback
import vn.jth.xverifysdk.network.models.request.bio.OnboardFaceRequestModel
import vn.jth.xverifysdk.network.models.request.bio.OnboardOTPRequestModel
import vn.jth.xverifysdk.network.models.request.bio.TransactionFaceRequestModel
import vn.jth.xverifysdk.network.models.response.ResponseModel
import vn.jth.xverifysdk.network.models.response.VerifyOCRResponseModel
import vn.jth.xverifysdk.network.models.response.bio.OnboardStateResponseModel
import vn.jth.xverifysdk.network.models.response.bio.RARResponseModel
import vn.jth.xverifysdk.network.models.response.bio.TransactionStatus
import vn.jth.xverifysdk.network.models.response.ekyb.DocumentDataResponseModel
import vn.jth.xverifysdk.network.models.response.ekyb.TaxcodeVerifyAdvanceResModel
import vn.jth.xverifysdk.network.models.response.ekyb.TaxcodeVerifyInfoResModel
import vn.jth.xverifysdk.network.models.response.ekyb.VerifyDocumentResponseModel
import vn.jth.xverifysdk.utils.StringUtils
import vn.jth.xverifysdk.vision.core.StepFace
import java.io.File
import java.util.UUID

class MainActivity: FlutterActivity(){
    companion object {
        private val TAG = MainActivity::class.java.name
        private val CHANNEL_NAME = "APP_CHANNEL"
        private const val NFC_FRAGMENT_TAG = "NFC_FRAGMENT_TAG"
    }

    private var methodChannel: MethodChannel? = null
    private var nfcAdapter: NfcAdapter? = null
    private var pendingIntent: PendingIntent? = null
    private var disposable = CompositeDisposable()
    private var mHandler = Handler(Looper.getMainLooper())
    private var isAllowReadNfc = false


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        registerPlatformViews(flutterEngine)
        methodChannel?.setMethodCallHandler { call, result ->
            handleFlutterChannel(call, result)
        }

    }

    private fun registerPlatformViews(flutterEngine: FlutterEngine) {
        val views = mapOf<String, PlatformViewFactory>(
            "<camera_mrz_view>" to CameraMrzFactory(methodChannel),
            "<camera_liveness_view>" to CameraLivenessFactory(methodChannel),
            "<camera_qr_view>" to CameraQrFactory(methodChannel)

        )
        for ((viewId, factory) in views) {
            flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory(viewId, factory)
        }
    }

    private fun handleFlutterChannel(call: MethodCall, result: MethodChannel.Result) {
        when (FlutterChannelConstant.valueOf(call.method)) {

            FlutterChannelConstant.VERIFY_EID_METHOD -> {
                val method = call.argument<String>("method")
                val data = call.argument<Map<String, Any>>("data")
                startSessionNfc(method, data)
            }

            FlutterChannelConstant.CANCEL_SESSION_NFC -> { onDisableNfc() }


            FlutterChannelConstant.SEND_ENV_METHOD -> {
                setUpEnv(call, result)
            }

            FlutterChannelConstant.SEND_BUSINESS_TYPE -> {
                val business: String? = call.argument("business") as String?
                if (business != null) {
                    ONBOARDDATAMANAGER.businessType = BusinessType.valueOf(business)
                } else {
                    result.error("1", "Business type is null", "")
                    return
                }
            }
            FlutterChannelConstant.SEND_DEVICE_ID->{
                val deviceId: String? = call.argument("deviceId") as String?
             ONBOARDDATAMANAGER.deviceId = deviceId
            }

            FlutterChannelConstant.DECODE_MRZ_BY_PATH -> {
                val image: String? = call.argument("path") as String?
                if (image == null) {
                    result.error("100", "Image path null", "")
                    return
                }
                decodeMrzFromImage(image)
            }

            FlutterChannelConstant.VERIFY_EKYC_METHOD -> {
                getInfoVerifyEkycFromCrossPlatform(call, result)
            }
            FlutterChannelConstant.GET_CARD_TYPE ->{
                val type = ONBOARDDATAMANAGER.eid?.getCardType().toString()
                result.success(type)
            }

            FlutterChannelConstant.REQUEST_VERIFY_FACE_BIOMETRIC->{
                val image: String? = call.argument("path") as String?
                requestOnBoardingFace(image)
            }
            FlutterChannelConstant.REQUEST_BIO_VERIFY_OTP->{
               requestVerifyOnboardOTP()
            }

            FlutterChannelConstant.REQUEST_BIO_VERIFY_FACE_TRANSFER->{
                val image: String? = call.argument("path") as String?
                requestVerifyTransfer(image)
            }

            FlutterChannelConstant.REQUEST_VERIFY_OCR -> {
                requestVerifyOCR(call, result)
            }

            FlutterChannelConstant.REQUEST_GET_DATA_ONBOARD_SUCCESS->{
                result.success(getDataOnboardSuccess())
            }

            FlutterChannelConstant.REQUEST_GET_DATA_TRANSFER_SUCCESS->{
                result.success(getDataTransferSuccess())
            }

            FlutterChannelConstant.REQUEST_CHECK_ONBOARDING_STATE -> {
                checkOnboardingStatus()
            }

            FlutterChannelConstant.REQUEST_SCAN_EKYB ->{
                val filePaths = call.argument<List<String>>("filePaths")
                val documentTypes = call.argument<String>("documentType")

                onRequestVerifyEKYB(filePaths!!,documentTypes!!,result)
            }

            FlutterChannelConstant.VERIFY_TAX_CODE_ADVANCE ->{
                val taxCode = call.argument<String>("taxCode")
                onVerifyTaxCodeAdvance(taxCode!!,result)
            }

            else -> result.notImplemented()
        }
    }

    //--------------------------------------------------
    //                 region PRIVATE
    //-------------------------------------------------
    private fun setUpEnv(call: MethodCall, result: MethodChannel.Result) {
        val envVariables: MutableMap<String, String>? =
            call.arguments as MutableMap<String, String>?
        if (envVariables == null) {
            result.error("1", "Missing env", "")
            return
        }
        ApiConfig.API_BASE_URL = envVariables["API_BASE_URL"]!!
        ApiConfig.API_BIO2345_BASE_URL = envVariables["API_BIO2345_BASE_URL"]!!
        ApiConfig.API_KEY = envVariables["API_KEY"]!!
        ApiConfig.CUSTOMER_CODE = envVariables["CUSTOMER_CODE"]!!

        APISERVICE.init(ApiConfig.API_KEY, ApiConfig.API_BASE_URL, ApiConfig.CUSTOMER_CODE)
        BIOAPISERVICE.init(
            ApiConfig.API_KEY,
            ApiConfig.API_BIO2345_BASE_URL,
            ApiConfig.CUSTOMER_CODE
        )
        result.success("Config API success")
    }

    private fun getInfoVerifyEkycFromCrossPlatform(call: MethodCall, result: MethodChannel.Result) {
        val map: MutableMap<String, Any>? = call.arguments as MutableMap<String, Any>?
        if (map != null) {
            val isRandom = map["isRandom"] as Boolean
            val verifySpoof = map["verifySpoof"] as Boolean
            val actions = map["actions"] as List<String>?

            if (actions.isNullOrEmpty()) {
                result.error("2", "Need to init steps face. Can not livness", "")
                return
            }
            ONBOARDDATAMANAGER.isRandomActions = isRandom
            ONBOARDDATAMANAGER.isVerifySpoof = verifySpoof
            val stepFace = arrayListOf<StepFace>()
            for (i in actions) {
                stepFace.add(StepFace.valueOf(i))
            }
            ONBOARDDATAMANAGER.steps = stepFace
        } else {
            result.error("100", "Not found require data", "")
        }
    }

    //--------------------------------------------------
    //                 endregion
    //-------------------------------------------------


    //--------------------------------------------------
    //                 region EKYB
    //-------------------------------------------------
    private fun onRequestVerifyEKYB(filePaths : List<String>, documentType: String, resultMethodChannel: MethodChannel.Result) {

        val document: DocumentType = DocumentType.reference(documentType)

        val fileList: List<File> = filePaths.map { File(it) }

        val callback = object :
            RestCallback<ResponseModel<VerifyDocumentResponseModel<DocumentDataResponseModel>>>() {
            override fun Success(response: ResponseModel<VerifyDocumentResponseModel<DocumentDataResponseModel>>) {
                val result = response.data.data
                if(result == null){
                    resultMethodChannel.error("300","Error from supplier","")
                    return
                }

                val preview = PreviewDocumentModel()
                if(document != DocumentType.reference(response.data.type!!)){
                    resultMethodChannel.error("300","Can not match type document","")
                    return
                }
                preview.typeDocument = result.documentType?.getLocalized(this@MainActivity)
                preview.businessName = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.name?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.businessName?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.businessHouseholdName?.value
                    else -> null
                }


                preview.textType = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.textType?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.textType?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.textType?.value
                    else -> null
                }

                preview.address = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.companyAddress?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.headquartersAddress?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.representative?.address?.value
                    else -> null
                }

                preview.placeOfIssue = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.placeOfIssue?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.placeOfIssue?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.placeOfIssue?.value
                    else -> null
                }

                preview.signer = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.signer?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.signer?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.signer?.value
                    else -> null
                }
                preview.taxcode = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.taxCode?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.taxCode?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.businessCode?.value
                    else -> null
                }

                preview.phoneNumber = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.phoneNumber?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.phoneNumber?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.phoneNumber?.value
                    else -> null
                }

                val representativeModel = RepresentativeModel()
                representativeModel.eId = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.representatives?.first()?.id?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.leader?.id?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.representative?.id?.value
                    else -> null
                }

                representativeModel.fullName = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.representatives?.first()?.name?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.leader?.name?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.representative?.name?.value
                    else -> null
                }

                representativeModel.dateOfBirth = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.representatives?.first()?.dob?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.leader?.dob?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.representative?.dob?.value
                    else -> null
                }

                representativeModel.dateOfIssue = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.representatives?.first()?.documentIssueDate?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.leader?.documentIssueDate?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.representative?.documentIssueDate?.value
                    else -> null
                }

                representativeModel.address = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.representatives?.first()?.address?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.leader?.address?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.representative?.address?.value
                    else -> null
                }

                representativeModel.gender = when(result.documentType){
                    DocumentType.DKKD_DN -> result.businessInfo?.representatives?.first()?.gender?.value
                    DocumentType.DKKD_CN -> result.branchInfo?.leader?.gender?.value
                    DocumentType.DKKD_HKD -> result.householdInfo?.representative?.gender?.value
                    else -> null
                }
                preview.representativeModel = representativeModel

                resultMethodChannel.success(dataToJson(preview).toString())

            }

            override fun Error(errorMessage: String) {
                resultMethodChannel.error("500",errorMessage,"")
            }
        }

        ApiService.APISERVICE.verifyDocumentBusiness(fileList, document!!, callback)
    }

    private fun onVerifyTaxCodeAdvance(taxCode: String, resultMethodChannel: MethodChannel.Result) {
        ApiService.APISERVICE.verifyTaxcodeAdvance(
            taxCode,
            object :
                RestCallback<ResponseModel<TaxcodeVerifyInfoResModel<TaxcodeVerifyAdvanceResModel>>>() {
                override fun Success(model: ResponseModel<TaxcodeVerifyInfoResModel<TaxcodeVerifyAdvanceResModel>>?) {
                    if (model?.success == false || model?.data == null) {
                        resultMethodChannel.error("500",model?.error.toString(),"")
                    }

                    val response= VerifyTaxCode()
                    val data = model?.data
                    Log.w("Phuc","Tax code rs: ${model?.data.toString()}")
                    val isValid = data?.isValid == true && data.responds?.status == "verified"
                    response.status = data?.responds?.status
                    response.isTaxCodeValid = data?.isValid?:false
                    response.taxCode = data?.responds?.company?.taxCode
                    response.phoneNumber = data?.responds?.company?.phoneNumber
                    response.name = data?.responds?.company?.name
                    response.businessStatus = data?.responds?.company?.businessStatus
                    response.companyAddress = data?.responds?.company?.companyAddress
                    response.companyRepresentativeId=data?.responds?.company?.representativeId
                    response.companyRepresentative=data?.responds?.company?.representative

                    if (isValid) {
                        Log.d("DEBUG", "response: ${model?.data}")
                        resultMethodChannel.success(dataToJson(response).toString())
                    } else {
                        println("test $response")
                        resultMethodChannel.error("500","Loại giấy tờ không hợp lệ","")
                    }
                }

                override fun Error(error: String?) {
                    resultMethodChannel.error("500",error.toString(),"")
                }
            })
    }

    private fun dataToJson(previewDoc: Any): JSONObject {
        val gson = Gson()
        val jsonStr = gson.toJson(previewDoc)

        val jsonObject = JSONObject(jsonStr)
        return jsonObject
    }

    //--------------------------------------------------
    //                endregion
    //-------------------------------------------------

    //--------------------------------------------------
    //                 region NFC
    //-------------------------------------------------

    private fun startSessionNfc(method:String?,result: Map<String, Any>?) {
        if(method == null) {
            throw NullPointerException("Unknown method scan qrcode or mrz")
        }else if(result == null){
            throw NullPointerException("Can not build mrzkey from null data")
        }

        ONBOARDDATAMANAGER.mrzInfo = null
        ONBOARDDATAMANAGER.basicInformation = null

        if (nfcAdapter == null) {
            nfcAdapter = NfcAdapter.getDefaultAdapter(activity)

            if (nfcAdapter == null) {
                methodChannel?.invokeMethod(
                    ChannelCallback.ON_ERROR_MESSAGE.name,
                    mapOf("message" to "Thiết bị không hỗ trợ NFC")
                )
                Log.e(TAG, "Thiết bị không hỗ trợ NFC")
                return
            }
            pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.getActivity(
                    this,
                    0,
                    Intent(context, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
                    PendingIntent.FLAG_MUTABLE
                )
            } else {
                PendingIntent.getActivity(
                    this,
                    0,
                    Intent(context, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
                    PendingIntent.FLAG_UPDATE_CURRENT
                )
            }
        }
        //Build MRZ or BasicInformation
        if(method == "MRZ"){
            val mrzInfo = MRZInfo.createTD1MRZInfo(
                "I",
                "",
                result.get("documentNumber") as String,
                null,
                result.get("dateOfBirth") as String,
                Gender.UNKNOWN,
                result.get("dateOfExpiry") as String,
                "",
                null,
                null,
                null
            )
            ONBOARDDATAMANAGER.mrzInfo = mrzInfo
        }else{
            val basicInformation = BasicInformation().apply {
                eidNumber = result?.get("eidNumber") as String
                oldEidNumber = result?.get("oldEidNumber") as String
                fullName = result?.get("fullName") as String
                dateOfBirth = result?.get("dateOfBirth") as String
                gender = result?.get("gender") as String
                placeOfResidence = result?.get("placeOfResidence") as String
                dateOfIssue = result?.get("dateOfIssue") as String
                fatherName = result?.get("fatherName") as String
                motherName = result?.get("motherName") as String
            }
            ONBOARDDATAMANAGER.basicInformation = basicInformation
            ONBOARDDATAMANAGER.mrzInfo = EidFacade.createMrz(basicInformation.eidNumber,basicInformation.dateOfBirth,basicInformation.dateOfIssue)
        }
        isAllowReadNfc = true
        onEnableNfc()
    }

    override fun onNewIntent(intent: Intent) {
        if (NfcAdapter.ACTION_TAG_DISCOVERED == intent.action || NfcAdapter.ACTION_TECH_DISCOVERED == intent.action) {
            if (isAllowReadNfc) {
                handleNfc(intent)
            }
        } else {
            super.onNewIntent(intent)
        }
    }

    private fun handleNfc(intent: Intent?) {
        val nfcFragment = NfcFragment(this, null)
        val listenerNfc = object : NfcFragment.NfcResultCallback {
            override fun onSuccess() {
                ONBOARDDATAMANAGER.businessType?.let { businessType ->
                    val result =  if (businessType == BusinessType.VERIFY_BANK_TRANSFER) {
                      ONBOARDDATAMANAGER.eid!!.personOptionalDetails?.toMap()
                    } else {
                        getResultVerifyEid()
                    }
                    methodChannel?.invokeMethod(ChannelCallback.ON_VERIFY_EID_SUCCESS.name, result)
                }

                isAllowReadNfc = false
                onDisableNfc()
            }

            override fun onChangeState(state: NfcFragment.NfcState) {
                when (state) {
                    NfcFragment.NfcState.ON_START -> runOnUiThread {
                        methodChannel?.invokeMethod(ChannelCallback.ON_START_SESSION_NFC.name, null)
                    }

                    NfcFragment.NfcState.ON_FINISH -> {
                        runOnUiThread {
                            methodChannel?.invokeMethod(
                                ChannelCallback.ON_FINISH_NFC.name,
                                null
                            )
                        }
                    }

                    NfcFragment.NfcState.ON_VERIFYING_EID_WITH_RAR -> {
                        methodChannel?.invokeMethod(
                            ChannelCallback.ON_VERIFYING_EID_WITH_RAR.name,
                            null
                        )
                    }
                }
            }

            override fun onError(message: String?) {
                sendErrorMessage(message)
            }

        }
        nfcFragment.setCallback(listenerNfc)
        nfcFragment.handleNfcTag(intent)
    }

    private fun onEnableNfc() {
        if (nfcAdapter != null) {
            if (!nfcAdapter!!.isEnabled) {
                Toast.makeText(this, "Cần kích hoạt tính năng NFC", Toast.LENGTH_LONG).show()
                val intent = Intent(Settings.ACTION_WIRELESS_SETTINGS)
                startActivity(intent)
            }

            nfcAdapter!!.enableForegroundDispatch(this, pendingIntent, null, null)
        }
    }

    private fun onDisableNfc() {
        if (!disposable.isDisposed) {
            disposable.clear()
            disposable.dispose()
        }
        isAllowReadNfc = false
        nfcAdapter?.disableForegroundDispatch(this)
        pendingIntent = null
        nfcAdapter = null
    }
    //--------------------------------------------------
    //                 endregion NFC
    //-------------------------------------------------

    override fun onPause() {
        super.onPause()
        nfcAdapter?.disableForegroundDispatch(this)
    }


    private val decodeMrzListener = object : MRZCallback {
        override fun completionHandler(mrzInfo: MRZInfo) {
            ONBOARDDATAMANAGER.mrzInfo = mrzInfo
            methodChannel?.invokeMethod(
                ChannelCallback.ON_FINISH_MRZ.name,
                mapOf("mrzInfo" to Gson().toJson(mrzInfo.toMap()))
            )
            EidFacade.unregisterMrzListener()
        }

        override fun errorHandler(e: MRZException?) {
            runOnUiThread {
                methodChannel?.invokeMethod(
                    ChannelCallback.ON_ERROR_MESSAGE.name,
                    mapOf("message" to "Unable to decode the image")
                )
            }
            Log.e(TAG, "Decode Mrz: ${e?.message}")
            EidFacade.unregisterMrzListener()
        }
    }

    private fun decodeMrzFromImage(image: String) {
        val bitmap = BitmapFactory.decodeFile(image)
        EidFacade.registerMrzListener(decodeMrzListener)
        EidFacade.processMrz(bitmap, 0)
    }


    //=========================================================
    //  region OCR
    //=======================================================
    private fun requestVerifyOCR(call: MethodCall, result: MethodChannel.Result) {
        val map: Map<String, String>? = call.arguments as Map<String, String>?
        if (map == null) {
            result.error("1", "Not found image", "")
            return
        }
        val imageFront = map["image_front"] as String
        val imageBack = map["image_back"] as String

        APISERVICE.verifyOCR(
            imageFront,
            imageBack,
            object : RestCallback<ResponseModel<VerifyOCRResponseModel>>() {
                override fun Success(model: ResponseModel<VerifyOCRResponseModel>?) {
                    if (model?.data != null) {
                        methodChannel?.invokeMethod(
                            ChannelCallback.ON_VERIFY_OCR_SUCCESS.name,
                            model.data.toMap()
                        )
                    } else {
                        methodChannel?.invokeMethod(
                            ChannelCallback.ON_ERROR_MESSAGE.name,
                            mapOf("message" to getString(R.string.error_ocr_card))
                        )
                    }
                }

                override fun Error(error: String?) {
                    methodChannel?.invokeMethod(
                        ChannelCallback.ON_ERROR_MESSAGE.name,
                        mapOf("message" to if (!error.isNullOrEmpty()) error else getString(R.string.error))
                    )
                }

            })
    }

    //=======================================================
    // endregion
    //=======================================================


    //------------------------------------ BIO 2345 ----------------------------------//


    private fun checkOnboardingStatus() {
        BIOAPISERVICE.bioGetOnboardStatus(
            ONBOARDDATAMANAGER.deviceId,
            object : RestCallback<ResponseModel<OnboardStateResponseModel>>() {
                override fun Success(model: ResponseModel<OnboardStateResponseModel>?) {
                    if (model == null) {
                        sendErrorMessage("Lỗi hệ thống, thử lại sau!")
                        return
                    }
                    if (model.data == null) {
                        val errorMessage = model.error?.message
                        sendErrorMessage(
                            if (!errorMessage.isNullOrEmpty()) errorMessage else getString(
                               R.string.error_not_success
                            )
                        )
                        return
                    }

                    if (model.success == null) {
                        sendErrorMessage(getString(R.string.error_not_success))
                        return
                    }

                    if (model.success == true) {
                        methodChannel?.invokeMethod(
                            ChannelCallback.ON_RESULT_CHECK_ONBOARDING_STATUS.name,
                            mapOf("deviceId" to ONBOARDDATAMANAGER.deviceId, "onboardingState" to  model.data.onboardingState)
                        )
                    }
                }

                override fun Error(error: String?) {
                    sendErrorMessage(error)
                }
            })
    }

    private fun requestOnBoardingFace(pathFaceEKYC: String?) {
        if (pathFaceEKYC == null) {
            sendErrorMessage("Không tìm thấy hình ảnh")
            return
        }
        val requestModel = ONBOARDDATAMANAGER.verifyIdRequestModel
        val cardNumber =
            if (requestModel?.idCard.isNullOrEmpty()) getSharedPreferences(
                PreferencesKeys.KEY_SHARE_NAME, MODE_PRIVATE
            ).getString(PreferencesKeys.KEY_ID_CARD, "")
            else
                requestModel?.idCard

        val onboardFaceRequestModel = OnboardFaceRequestModel().apply {
            capturedImg = StringUtils.convertFileBitmapToBase64(pathFaceEKYC)
            idCard = cardNumber
            deviceUuid = ONBOARDDATAMANAGER.deviceId
        }

        BioApiService.BIOAPISERVICE.bioFaceVerification(
            UUID.randomUUID().toString(),
            onboardFaceRequestModel,
            object : RestCallback<ResponseModel<RARResponseModel>>() {
                override fun Success(model: ResponseModel<RARResponseModel>?) {
                    if (model == null) {
                        sendErrorMessage(getString(R.string.error_system))
                        return
                    }
                    if (model.data == null) {
                        val errorMessage = model.error?.message
                        sendErrorMessage(if (!errorMessage.isNullOrEmpty()) errorMessage else getString(
                            R.string.error_not_success
                        ))
                        return
                    }
                    if (model.data.isMatching == null) {
                        sendErrorMessage(getString(R.string.error_not_success))
                        return
                    }
                    if (model.data.isMatching == true) {
                        Utils.storeImageEid(
                            this@MainActivity,
                            ONBOARDDATAMANAGER.eid?.faceImage
                        ) {
                            ONBOARDDATAMANAGER.referenceFaceImagePath = it
                        }
                        ONBOARDDATAMANAGER.isFaceMatch = model.data.isMatching!!
                        ONBOARDDATAMANAGER.onboardingFaceImagePath = pathFaceEKYC

                        val share =
                            getSharedPreferences(
                                PreferencesKeys.KEY_SHARE_NAME,
                                MODE_PRIVATE
                            )
                        share.edit()
                            .putString(
                                PreferencesKeys.KEY_ID_CARD,
                                onboardFaceRequestModel.idCard
                            )
                            .apply()
                        share.edit().putString(
                            PreferencesKeys.KEY_ONBOARD_IMAGE,
                            onboardFaceRequestModel.capturedImg
                        ).apply()

                        mHandler.post {
                            methodChannel?.invokeMethod(
                                ChannelCallback.ON_BIO_VERIFY_FACE_MATCHING_SUCCESS.name,
                                mapOf("isFaceMatch" to ONBOARDDATAMANAGER.isFaceMatch)
                            )
                        }
                    } else {
                        sendErrorMessage("Khuôn mặt không trùng khớp")
                    }
                }

                override fun Error(error: String?) {
                    sendErrorMessage(if (!error.isNullOrEmpty()) error else getString(R.string.error))
                }
            })
    }

    private fun requestVerifyOnboardOTP() {
        val requestModel = ONBOARDDATAMANAGER.verifyIdRequestModel

        val cardNumber =
            if (requestModel?.idCard.isNullOrEmpty()) getSharedPreferences(PreferencesKeys.KEY_SHARE_NAME, MODE_PRIVATE)
                .getString(PreferencesKeys.KEY_ID_CARD,"")
            else
                requestModel?.idCard
        val onboardFaceRequestModel = OnboardOTPRequestModel().apply {
            otpTransactionCode = ""
            idCard = cardNumber
            otpConfirm = true
            deviceUuid = ONBOARDDATAMANAGER.deviceId
        }
        BIOAPISERVICE.bioConfirmOTP(
            UUID.randomUUID().toString(),
            onboardFaceRequestModel,
            object : RestCallback<ResponseModel<RARResponseModel>>() {
                override fun Success(model: ResponseModel<RARResponseModel>?) {
                    if (model == null) {
                        sendErrorMessage(getString(R.string.error_system))
                        return
                    }
                    if (model.data == null) {
                        val errorMessage = model.error?.message
                        sendErrorMessage(if (!errorMessage.isNullOrEmpty()) errorMessage else getString(
                            R.string.error_not_success
                        ))
                        finish()
                        return
                    }

                    if (model.success == null) {
                        sendErrorMessage(getString(R.string.error_not_success))
                        return
                    }

                    if (model.success == true) {
                        methodChannel?.invokeMethod(
                            ChannelCallback.ON_BIO_VERIFY_OTP_SUCCESS.name,
                            mapOf("isSuccess" to true)
                        )
                    } else {
                        sendErrorMessage(getString(R.string.error_not_success))
                    }

                }

                override fun Error(error: String?) {
                    sendErrorMessage(if (!error.isNullOrEmpty()) error else getString(R.string.error))
                }

            })
    }

    private fun getDataOnboardSuccess():Map<String,String?>{
        var eidInfo = getSharedPreferences(PreferencesKeys.KEY_SHARE_NAME, MODE_PRIVATE).getString(PreferencesKeys.KEY_EID, "")
        val jsonEidInfo: JSONObject = JSONObject(eidInfo)
        val sharedPreferences =  getSharedPreferences(PreferencesKeys.KEY_SHARE_NAME, MODE_PRIVATE)
        val chipImageBase64 = sharedPreferences.getString(PreferencesKeys.KEY_CHIP_IMAGE,"")
        val onboardImageBase64 = sharedPreferences.getString(PreferencesKeys.KEY_ONBOARD_IMAGE,"")

        val result = mapOf<String,String?>(
            "chipImageBase64" to chipImageBase64,
            "onboardImageBase64" to onboardImageBase64,
            "eid_number" to jsonEidInfo.getString("eid_number"),
            "full_name" to jsonEidInfo.getString("full_name"),
            "dob" to jsonEidInfo.getString("dob"),
            "gender" to jsonEidInfo.getString("gender"),
            "place_of_residence" to jsonEidInfo.getString("place_of_residence")
        )

        return result
    }
    private fun requestVerifyTransfer(faceLive : String?) {
        if (faceLive == null) {
            sendErrorMessage("Không tìm thấy hình ảnh")
            return
        }

        val idCardNumber = if(ONBOARDDATAMANAGER.verifyIdRequestModel?.idCard.isNullOrEmpty()) getSharedPreferences(
            KEY_SHARE_NAME, MODE_PRIVATE).getString(
            KEY_ID_CARD,"") else ONBOARDDATAMANAGER.verifyIdRequestModel?.idCard
        val transactionFaceRequestModel =  TransactionFaceRequestModel().apply {
            deviceUuid = ONBOARDDATAMANAGER.deviceId
            idCard = idCardNumber
            bankTransactionType = "C"
            bankTransactionType = "C"
            capturedImg = StringUtils.convertFileBitmapToBase64(faceLive)
        }
        BIOAPISERVICE.bioFaceVerificationBankTransaction(
            UUID.randomUUID().toString()
            ,transactionFaceRequestModel, object: RestCallback<ResponseModel<RARResponseModel>>() {
                override fun Success(model: ResponseModel<RARResponseModel>?) {
                    if (model?.data != null && model.success == true && model.data.transactionStatus != null) {
                        ONBOARDDATAMANAGER.isFaceMatch = model.data.transactionStatus == TransactionStatus.BIOMETRIC_VERIFIED.code
                        mHandler.post {
                            methodChannel?.invokeMethod(
                                ChannelCallback.ON_BIO_VERIFY_FACE_MATCHING_SUCCESS.name,
                                mapOf("isFaceMatch" to ONBOARDDATAMANAGER.isFaceMatch)
                            )
                        }
                    } else {
                        sendErrorMessage("Giao dịch không thành công.")
                    }
                }

                override fun Error(error: String?) {
                    sendErrorMessage(if (!error.isNullOrEmpty()) error else getString(R.string.error))
                }

            })
    }

    private fun getDataTransferSuccess():Map<String,Any?>{
        val sharedPreferences =  getSharedPreferences(PreferencesKeys.KEY_SHARE_NAME, MODE_PRIVATE)
        val chipImageBase64 = sharedPreferences.getString(PreferencesKeys.KEY_CHIP_IMAGE,"")
        val onboardImageBase64 = sharedPreferences.getString(PreferencesKeys.KEY_ONBOARD_IMAGE,"")

        val result = mapOf<String,String?>(
            "chipImageBase64" to chipImageBase64,
            "onboardImageBase64" to onboardImageBase64,

            )
        return result
    }
    private fun sendErrorMessage(message: String?) {
        mHandler.post {
            methodChannel?.invokeMethod(
                ChannelCallback.ON_ERROR_MESSAGE.name,
                mapOf("message" to (message ?: "Có lỗi xảy ra, thử lại sau"))
            )
        }
    }
}
