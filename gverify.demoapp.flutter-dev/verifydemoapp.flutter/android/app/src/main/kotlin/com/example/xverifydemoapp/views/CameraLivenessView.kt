package com.example.xverifydemoapp.views

import android.content.Context
import android.content.ContextWrapper
import android.os.Handler
import android.os.Looper
import android.view.View
import androidx.camera.core.CameraSelector
import androidx.camera.view.LifecycleCameraController
import androidx.camera.view.PreviewView
import androidx.lifecycle.LifecycleOwner
import com.example.xverifydemoapp.utils.BusinessType
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import com.example.xverifydemoapp.utils.ChannelCallback
import com.example.xverifydemoapp.utils.ONBOARDDATAMANAGER
import vn.jth.xverifysdk.vision.ActiveEkycUtils
import vn.jth.xverifysdk.vision.ActiveEkycUtils.EKYCSERVICE
import vn.jth.xverifysdk.vision.EkycLivenessListener
import vn.jth.xverifysdk.vision.EkycVerificationMode
import vn.jth.xverifysdk.vision.EkycVerifyError
import vn.jth.xverifysdk.vision.EkycVerifyListener
import vn.jth.xverifysdk.vision.core.StepFace


class CameraLivenessView(context: Context, private val methodChannel: MethodChannel?) :
    PlatformView {

    private var cameraView: PreviewView? = null
    private var cameraSelector: CameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA
    private var cameraController: LifecycleCameraController? = null
    private var verifyMode: EkycVerificationMode = EkycVerificationMode.LIVENESS
    private var mHandler = Handler(Looper.getMainLooper())
    private var steps :ArrayList<StepFace> = arrayListOf(StepFace.FACE_CENTER, StepFace.SMILE)

    private fun startCamera(context: Context) {
        val lifecycleOwner = getLifecycleOwner(context)
            ?: throw IllegalStateException("LifecycleOwner not found in context hierarchy")
        cameraController = LifecycleCameraController(context)
        cameraController!!.bindToLifecycle(lifecycleOwner)
        cameraController!!.cameraSelector = cameraSelector
        cameraView!!.controller = cameraController

        EKYCSERVICE.init(
            context,
            cameraController,
            ONBOARDDATAMANAGER.eid?.faceImage,
            verifyMode,
            faceListener,
            onVerifyListener,
            steps,
            ONBOARDDATAMANAGER.isRandomActions, ONBOARDDATAMANAGER.isVerifySpoof
        )
        EKYCSERVICE.setCameraController(cameraController)
        EKYCSERVICE.startAnalysis()

    }

    //========================================================
    //          LISTENER
    //=======================================================


    private val faceListener: EkycLivenessListener = object : EkycLivenessListener {
        override fun onMultiFace() {
            mHandler.post{
                methodChannel?.invokeMethod(
                    ChannelCallback.ON_STEP_LIVENESS.name,
                    mapOf("step" to "ON_MULTI_FACE")
                )
            }
        }

        override fun onNoFace() {
            mHandler.post {
                methodChannel?.invokeMethod(
                    ChannelCallback.ON_STEP_LIVENESS.name,
                    mapOf("step" to "ON_NO_FACE")
                )
            }
        }

        override fun onPlaySound() {
            methodChannel?.invokeMethod(
                ChannelCallback.ON_PLAY_SOUND.name,
               null
            )
        }

        override fun onStep(step: StepFace) {
            mHandler.post {
                methodChannel?.invokeMethod(
                    ChannelCallback.ON_STEP_LIVENESS.name,
                    mapOf("step" to step.name)
                )
            }
        }
    }


    private val onVerifyListener: EkycVerifyListener = object : EkycVerifyListener {
        override fun onProcess() {
            mHandler.post{
                methodChannel?.invokeMethod(ChannelCallback.ON_VERIFYING_FACE_LIVENESS.name,mapOf("message" to "Verifying Face"))
            }
        }

        override fun onFinishProcess() {
            mHandler.post{
                methodChannel?.invokeMethod(ChannelCallback.ON_VERIFY_FACE_LIVENESS_FINISH.name,null)
            }
        }


        override fun onFailed(
            error: String,
            capturedFace: String?,
            ekycVerificationMode: EkycVerificationMode,
            errorCodes: EkycVerifyError
        ) {
            mHandler.post{
                methodChannel?.invokeMethod(
                    ChannelCallback.ON_ERROR_MESSAGE.name,
                    mapOf(
                        "message" to error
                    )
                )
            }
            Handler().postDelayed({
                EKYCSERVICE.resetAnalysis()
            },2000)
        }

        override fun onVerifyCompleted(
            ekycVerificationMode: EkycVerificationMode,
            verifyLiveness: Boolean,
            verifyFaceMatch: Boolean,
            capturedFace: String,
        ) {
            ActiveEkycUtils.EKYCSERVICE.stopAnalysisImage()
            cameraController?.clearImageAnalysisAnalyzer()
            mHandler.post {
                methodChannel?.invokeMethod(
                    ChannelCallback.ON_LIVENESS_SUCCESS.name,
                    mapOf(
                        "isMatching" to verifyFaceMatch,
                        "isVerifyLiveness" to verifyLiveness,
                        "image" to capturedFace
                    )
                )
            }
        }

    }


    init {
        verifyMode = when (ONBOARDDATAMANAGER.businessType) {
            BusinessType.VERIFY_EID_ACTIVE_EKYC -> EkycVerificationMode.VERIFY_LIVENESS_FACE_MATCHING
            BusinessType.VERIFY_EID_SIMPLE_EKYC, BusinessType.VERIFY_OCR, BusinessType.VERIFY_EKYB -> EkycVerificationMode.LIVENESS_FACE_MATCHING
            else -> EkycVerificationMode.LIVENESS
        }
        if(ONBOARDDATAMANAGER.steps!=null){
            steps = ONBOARDDATAMANAGER.steps!!
        }else{
            verifyMode = EkycVerificationMode.LIVENESS
        }

        cameraView = PreviewView(context)
        cameraView!!.scaleType = PreviewView.ScaleType.FILL_CENTER
        cameraView!!.implementationMode = PreviewView.ImplementationMode.COMPATIBLE
        startCamera(context)
    }

    //=====================================================
    //
    //=======================================================

    private fun getLifecycleOwner(context: Context): LifecycleOwner? {
        var currentContext = context
        while (currentContext is ContextWrapper) {
            if (currentContext is LifecycleOwner) {
                return currentContext
            }
            currentContext = currentContext.baseContext
        }
        return null
    }

    override fun getView(): View? {
        return cameraView
    }

    override fun dispose() {
        cameraController?.unbind()
        cameraView = null
        cameraController = null
    }
}