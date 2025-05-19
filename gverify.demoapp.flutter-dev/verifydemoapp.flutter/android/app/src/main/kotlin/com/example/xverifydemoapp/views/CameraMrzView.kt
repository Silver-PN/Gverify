package com.example.xverifydemoapp.views

import android.annotation.SuppressLint
import android.content.Context
import android.content.ContextWrapper
import android.view.View
import androidx.camera.core.CameraSelector
import androidx.camera.view.LifecycleCameraController
import androidx.camera.view.PreviewView
import androidx.lifecycle.LifecycleOwner
import com.google.gson.Gson
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.jmrtd.lds.icao.MRZInfo
import com.example.xverifydemoapp.extentions.toMap
import com.example.xverifydemoapp.utils.ChannelCallback
import vn.jth.xverifysdk.card.EidFacade
import vn.jth.xverifysdk.card.MRZCallback
import vn.jth.xverifysdk.card.MRZException
import vn.jth.xverifysdk.vision.ocr.TextRecognitionAnalyzer
import java.util.concurrent.Executors


@SuppressLint("InflateParams")
internal class CameraMrzView(context: Context, private val methodChannel: MethodChannel?) : PlatformView{
    private var cameraView:PreviewView ?=null
    private var cameraSelector: CameraSelector = CameraSelector.DEFAULT_BACK_CAMERA
    private var cameraController: LifecycleCameraController?=null
    private var isDecodeMrzSuccess = false


    private val mrzListener = object : MRZCallback{
        override fun completionHandler(mrzInfo: MRZInfo) {
            if(isDecodeMrzSuccess) return
            isDecodeMrzSuccess = true
            methodChannel?.invokeMethod(ChannelCallback.ON_FINISH_MRZ.name, mapOf("mrzInfo" to Gson().toJson(mrzInfo.toMap())))
            EidFacade.unregisterMrzListener(this)
        }

        override fun errorHandler(e: MRZException?) {
        }
    }


    init {
        cameraController?.unbind()
        cameraController = null
        isDecodeMrzSuccess = false
        cameraView = PreviewView(context)
        cameraView!!.scaleType = PreviewView.ScaleType.FILL_CENTER
        cameraView!!.implementationMode = PreviewView.ImplementationMode.COMPATIBLE
        EidFacade.registerMrzListener(mrzListener)
        startCamera(context)
    }


    private fun startCamera(context: Context){

        val lifecycleOwner = getLifecycleOwner(context)
            ?: throw IllegalStateException("LifecycleOwner not found in context hierarchy")
        cameraController = LifecycleCameraController(context)
        cameraController!!.bindToLifecycle(lifecycleOwner)
        cameraController!!.cameraSelector = cameraSelector
        cameraController!!.setImageAnalysisAnalyzer(Executors.newSingleThreadExecutor(),
            TextRecognitionAnalyzer()
        )
        cameraView!!.controller = cameraController
    }

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
        cameraView = null
        cameraController?.unbind()
        cameraController = null
        EidFacade.unregisterMrzListener()
    }


}