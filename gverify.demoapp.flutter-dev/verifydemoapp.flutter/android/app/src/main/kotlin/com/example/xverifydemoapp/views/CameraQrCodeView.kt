package com.example.xverifydemoapp.views

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import android.util.Size
import android.view.View
import androidx.annotation.OptIn
import androidx.camera.core.Camera
import androidx.camera.core.CameraSelector
import androidx.camera.core.ExperimentalGetImage
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import com.google.gson.Gson
import com.google.mlkit.vision.barcode.BarcodeScannerOptions
import com.google.mlkit.vision.barcode.ZoomSuggestionOptions
import com.google.mlkit.vision.barcode.common.Barcode
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import com.example.xverifydemoapp.extentions.toMap
import com.example.xverifydemoapp.utils.ChannelCallback
import com.example.xverifydemoapp.utils.Utils
import com.example.xverifydemoapp.visio.QRCodeAndBarcodeAnalyzer
import vn.jth.xverifysdk.data.BasicInformation


@SuppressLint("SuspiciousIndentation")
class CameraQrCodeView(private val context: Context, private val methodChannel: MethodChannel?) :
    PlatformView, QRCodeAndBarcodeAnalyzer.QrCodeListener {

    private var cameraView: PreviewView? = null
    private var cameraSelector: CameraSelector = CameraSelector.DEFAULT_BACK_CAMERA
    private var cameraProvider: ProcessCameraProvider? = null
    private var camera: Camera? = null
    private var imageAnalyzer: ImageAnalysis? = null
    private var isDecodeSuccess = false

    private var options = BarcodeScannerOptions.Builder()
        .enableAllPotentialBarcodes()
        .setBarcodeFormats(
            Barcode.FORMAT_QR_CODE
        )

    init {
        cameraView = PreviewView(context)
        cameraView!!.scaleType = PreviewView.ScaleType.FILL_CENTER
        cameraView!!.implementationMode = PreviewView.ImplementationMode.COMPATIBLE
                startCamera()
    }


    //====================================
    // region CAMERA
    //====================================
    @OptIn(ExperimentalGetImage::class)
    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
        cameraProviderFuture.addListener({
            cameraProvider = cameraProviderFuture.get()

            // Tạo Preview UseCase
            val preview = Preview.Builder().build().also {
                it.setSurfaceProvider(cameraView!!.surfaceProvider)
            }

            imageAnalyzer =  ImageAnalysis.Builder()
                .setTargetResolution(Size(1280, 720))
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()

            try {
                val lifecycleOwner = Utils.getLifecycleOwner(context)
                    ?: throw IllegalStateException("LifecycleOwner not found in context hierarchy")

                cameraProvider!!.unbindAll()
                camera = cameraProvider!!.bindToLifecycle(lifecycleOwner , cameraSelector, imageAnalyzer,preview)
                analyzer()
            } catch (exc: Exception) {
                Log.e(TAG, "Not init camera.", exc)
            }

        }, ContextCompat.getMainExecutor(context))
    }


    override fun getView(): View? {
        return cameraView
    }

    override fun dispose() {
        cameraView = null
        cameraProvider?.unbindAll()
        imageAnalyzer?.clearAnalyzer()
        imageAnalyzer = null
        cameraProvider = null
    }

    private fun analyzer(){
        val zoomCallback = ZoomSuggestionOptions.ZoomCallback { zoomLevel: Float ->
            Log.i("CameraQrCodeView", "Set zoom ratio $zoomLevel")
            val ignored = camera?.cameraControl?.setZoomRatio(zoomLevel)
            true
        }
        options.setZoomSuggestionOptions(ZoomSuggestionOptions.Builder(zoomCallback).build())
        imageAnalyzer?.setAnalyzer(ContextCompat.getMainExecutor(context),
            QRCodeAndBarcodeAnalyzer(options.build(),this)
        )
    }


    override fun onSuccess(basicInformation: BasicInformation) {
        imageAnalyzer?.clearAnalyzer()
        if(!isDecodeSuccess){
            isDecodeSuccess  = true
        methodChannel?.invokeMethod(ChannelCallback.ON_SCAN_QR_CODE_SUCCESS.name, mapOf("basicInformation" to Gson().toJson(basicInformation.toMap())))
    }
    }

    companion object{
        private val TAG = CameraQrCodeView::class.java.name
    }
}