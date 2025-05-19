package com.example.xverifydemoapp.views

import android.annotation.SuppressLint
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.DialogInterface
import android.content.Intent
import android.media.MediaPlayer
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.widget.AppCompatButton
import com.airbnb.lottie.LottieAnimationView
import com.example.xverifydemoapp.R
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.gson.JsonObject
import io.reactivex.disposables.CompositeDisposable
import net.sf.scuba.smartcards.CardServiceException
import org.jmrtd.BACDeniedException
import org.jmrtd.PACEException
import org.jmrtd.TagLostConnectException

import com.example.xverifydemoapp.utils.ApiConfig
import com.example.xverifydemoapp.utils.BusinessType

import com.example.xverifydemoapp.utils.ONBOARDDATAMANAGER
import com.example.xverifydemoapp.utils.PreferencesKeys
import com.example.xverifydemoapp.utils.Utils
import vn.jth.xverifysdk.card.EidCallback
import vn.jth.xverifysdk.card.EidFacade
import vn.jth.xverifysdk.card.EidReadData
import vn.jth.xverifysdk.data.Eid
import vn.jth.xverifysdk.jmrtd.VerificationStatus
//import vn.jth.xverifysdk.network.ApiService.APISERVICE
import vn.jth.xverifysdk.network.ApiService.Companion.APISERVICE
import vn.jth.xverifysdk.network.BioApiService.BIOAPISERVICE
import vn.jth.xverifysdk.network.models.RestCallback
import vn.jth.xverifysdk.network.models.request.VerifyIdResquestModel
import vn.jth.xverifysdk.network.models.request.bio.RARRequestModel
import vn.jth.xverifysdk.network.models.response.ResponseModel
import vn.jth.xverifysdk.network.models.response.VerifyIdResponseModel
import vn.jth.xverifysdk.network.models.response.bio.RARResponseModel
import vn.jth.xverifysdk.utils.StringUtils
import java.util.UUID

@SuppressLint("InflateParams")
class NfcFragment(private val context: Context,private var callback: NfcResultCallback?) {
    private var disposable = CompositeDisposable()
    private var mHandler = Handler(Looper.getMainLooper())



     fun handleNfcTag(intent: Intent?) {
        if (intent == null || intent.extras == null) {
            return
        }

        val tag = intent.getParcelableExtra<Tag>(NfcAdapter.EXTRA_TAG) ?: return
        val subscribe = EidFacade.readChipNfc(
            context,
            tag,
            ONBOARDDATAMANAGER.mrzInfo,
            ONBOARDDATAMANAGER.basicInformation,
            object : EidCallback {

                override fun onEidReadStart() {
                    Log.d(TAG, "Start Session Read NFC")
                    callback?.onChangeState(NfcState.ON_START)
                }

                override fun onEidReadFinish() {
                    Log.i(TAG, "Finish Session Read NFC")
                    callback?.onChangeState(NfcState.ON_FINISH)
                }

                override fun onEidRead(eid: Eid?) {
                    ONBOARDDATAMANAGER.eid = eid
                    val dataIntegrity =
                        ONBOARDDATAMANAGER.eid?.chipAuthenticationStatus == VerificationStatus.Verdict.SUCCEEDED
                                && ONBOARDDATAMANAGER.eid?.passiveAuthenticationStatus == VerificationStatus.Verdict.SUCCEEDED
                                && ONBOARDDATAMANAGER.eid?.activeAuthenticationStatus == VerificationStatus.Verdict.SUCCEEDED
                    if (!dataIntegrity) {
                        callback?.onError(context.getString(R.string.authenticated_card_error))
                        return
                    }

                    readDataSuccess(eid)
                }

                @SuppressLint("SetTextI18n")
                override fun onEidReading(type: EidReadData) {
                    super.onEidReading(type)
                }

                override fun onTagLostException(exception: TagLostConnectException) {
                    handleExceptionNfc(context.getString(R.string.tag_lost))
                }

                override fun onBACDeniedException(exception: BACDeniedException) {
                    handleExceptionNfc(context.getString(R.string.authentication_incorrect))
                }

                override fun onPACEException(exception: PACEException) {
                    handleExceptionNfc(context.getString(R.string.authentication_incorrect))
                }

                override fun onCardException(exception: CardServiceException) {
                    Log.e(TAG, "Error: ${exception.message}")
                    handleExceptionNfc(exception.message)
                }

                override fun onGeneralException(exception: Exception?) {
                    Log.e(TAG, "Error: ${exception?.message}")
                    handleExceptionNfc(exception?.message)
                }
            })

        disposable.add(subscribe)

    }

    private fun handleExceptionNfc(message: String?){
        callback?.onError(message)
    }


    private fun readDataSuccess(eid:Eid?){
        val deviceID = ONBOARDDATAMANAGER.deviceId
        val requestModel = VerifyIdResquestModel()
        requestModel.dsCert =
            StringUtils.encodeToBase64String(eid?.documentSigningCertificate)
        requestModel.code = ApiConfig.CUSTOMER_CODE
        requestModel.province =
            StringUtils.getProvince(StringUtils.getProvince(eid?.personOptionalDetails?.placeOfOrigin))
        requestModel.idCard = eid?.personOptionalDetails?.eidNumber
        requestModel.deviceType = "mobile-$deviceID"
        requestModel.requestId = UUID.randomUUID().toString()
        ONBOARDDATAMANAGER.verifyIdRequestModel = requestModel


        val verificationAction = if (ONBOARDDATAMANAGER.businessType == BusinessType.VERIFY_BANK_TRANSFER) {
            ::requestBioRarVerification
        } else {
            ::verifySignatureWithRAR
        }

        verificationAction { success ->
            if (success) {
                callback?.onSuccess()
            } else {
                callback?.onError(context.getString(R.string.error_not_success))
            }
        }


    }

    private fun verifySignatureWithRAR(result: (Boolean) -> Unit) {
        callback?.onChangeState(NfcState.ON_VERIFYING_EID_WITH_RAR)
        val requestModel = ONBOARDDATAMANAGER.verifyIdRequestModel
        APISERVICE.verifyEid(
            requestModel!!,
            object : RestCallback<ResponseModel<VerifyIdResponseModel>>() {
                override fun Success(model: ResponseModel<VerifyIdResponseModel>?) {
                    //response check
                    if (model == null) {
                        callback?.onError(context.getString(R.string.error_system))
                        return
                    }
                    //data check
                    if (model.data == null) {
                        val errorMessage = model.error?.message
                        callback?.onError( if (!errorMessage.isNullOrEmpty()) errorMessage else context.getString(
                            R.string.error_not_success
                        ))
                        return
                    }
                    // validate check
                    val isValidIdCard = model.data.isValidIdCard
                    if (isValidIdCard) {
                        val respondsMsg = model.data.responds.toJsonString()
                        val signature = model.data?.signature ?: ""
                        //verify signature with RAR
                        ONBOARDDATAMANAGER.eid?.verifyRsaSignature(context, signature, respondsMsg)
                    }

                    ONBOARDDATAMANAGER.isValidIdCard =
                        isValidIdCard && ONBOARDDATAMANAGER.eid?.dsCertChecksumVerified == true

                    if (ONBOARDDATAMANAGER.isValidIdCard) {
                        ONBOARDDATAMANAGER.eid?.faceImage?.let { face ->
                            Utils.storeImageEid(context, face) {
                                ONBOARDDATAMANAGER.referenceFaceImagePath = it
                            }
                        }
                    }
                    result(ONBOARDDATAMANAGER.isValidIdCard)
                }

                override fun Error(error: String?) {
                    Log.e(TAG, "Error: $error")
                    callback?.onError( if (!error.isNullOrEmpty()) error else context.getString(R.string.error_not_success))
                    result(ONBOARDDATAMANAGER.isValidIdCard)
                }
            })
    }


    private fun requestBioRarVerification(result: (Boolean) -> Unit) {
        callback?.onChangeState(NfcState.ON_VERIFYING_EID_WITH_RAR)
        val rarRequestModel = RARRequestModel()
        rarRequestModel.requestId = UUID.randomUUID().toString()
        rarRequestModel.deviceUuid = ONBOARDDATAMANAGER.deviceId
        rarRequestModel.province = StringUtils.getProvince(ONBOARDDATAMANAGER.eid?.personOptionalDetails?.placeOfOrigin)
        rarRequestModel.personalIdentification = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.personalIdentification
        rarRequestModel.placeOfOrigin  = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.placeOfOrigin
        rarRequestModel.chipImg  = StringUtils.bitmapToBase64(ONBOARDDATAMANAGER.eid?.faceImage!!).replace("\n","")
        rarRequestModel.dateOfBirth  = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.dateOfBirth
        rarRequestModel.dateOfExpiry = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.dateOfExpiry
        rarRequestModel.dateOfIssue = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.dateOfIssue
        rarRequestModel.deviceName =  Build.MODEL
        rarRequestModel.deviceType = "mobile-${ONBOARDDATAMANAGER.deviceId}"
        rarRequestModel.dsCert = ONBOARDDATAMANAGER.verifyIdRequestModel?.dsCert
        rarRequestModel.fatherName = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.fatherName
        rarRequestModel.fullName = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.fullName
        rarRequestModel.gender = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.gender
        rarRequestModel.idCard = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.eidNumber
        rarRequestModel.motherName = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.motherName
        rarRequestModel.nationality = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.nationality
        rarRequestModel.oldIdCard = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.oldEidNumber
        rarRequestModel.placeOfResidence = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.placeOfResidence
        rarRequestModel.race = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.ethnicity
        rarRequestModel.religion = ONBOARDDATAMANAGER.eid?.personOptionalDetails?.religion

        BIOAPISERVICE.bioVerifyRAR(rarRequestModel, object: RestCallback<ResponseModel<RARResponseModel>>() {
            override fun Success(model: ResponseModel<RARResponseModel>?) {
                if (model == null) {
                    callback?.onError(context.getString(R.string.error_system))
                    return
                }
                if (model.data == null) {
                    val errorMessage = model.error?.message
                    callback?.onError( if (!errorMessage.isNullOrEmpty()) errorMessage else context.getString(
                        R.string.error_not_success
                    ))
                    return
                }
                var rarVerified = false
                if (model.data.responds == null) {
                    rarVerified = false
                } else {
                    model.data.responds?.let { rarVerified = it.result?:false }
                }
                ONBOARDDATAMANAGER.isValidIdCard = true
                val share = context.getSharedPreferences(PreferencesKeys.KEY_SHARE_NAME, MODE_PRIVATE)
                share.edit().putString(PreferencesKeys.KEY_ID_CARD, ONBOARDDATAMANAGER.eid?.personOptionalDetails?.eidNumber).apply()
                share.edit().putString(
                    PreferencesKeys.KEY_CHIP_IMAGE, StringUtils.bitmapToBase64(
                    ONBOARDDATAMANAGER.eid?.faceImage!!).replace("\n","")).apply()
                val json = JsonObject()
                json.addProperty("eid_number", ONBOARDDATAMANAGER.eid?.personOptionalDetails?.eidNumber)
                json.addProperty("full_name", ONBOARDDATAMANAGER.eid?.personOptionalDetails?.fullName)
                json.addProperty("dob", ONBOARDDATAMANAGER.eid?.personOptionalDetails?.dateOfBirth)
                json.addProperty("gender", ONBOARDDATAMANAGER.eid?.personOptionalDetails?.gender)
                json.addProperty("place_of_residence", ONBOARDDATAMANAGER.eid?.personOptionalDetails?.placeOfResidence)
                share.edit().putString(PreferencesKeys.KEY_EID, json.toString()).apply()
                result(rarVerified)
            }

            override fun Error(error: String?) {
                ONBOARDDATAMANAGER.isValidIdCard = false
                Log.e(TAG, "Error: $error")
                callback?.onError( if (!error.isNullOrEmpty()) error else context.getString(R.string.error_not_success))
            }

        })
    }


    fun setCallback(callback: NfcResultCallback){
        this.callback = callback
    }
    enum class NfcState{
        ON_START, ON_FINISH,ON_VERIFYING_EID_WITH_RAR
    }

    interface NfcResultCallback{
        fun onSuccess()
        fun onChangeState(state: NfcState)
        fun onError(message:String?)
    }

    companion object{
        private val TAG = NfcFragment::class.java.name
    }

}