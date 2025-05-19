package com.example.xverifydemoapp.platforms

import android.content.Context
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import com.example.xverifydemoapp.views.CameraQrCodeView

class CameraQrFactory(private val methodChannel: MethodChannel?): PlatformViewFactory(
    StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        if (context == null) {
            throw IllegalArgumentException("Context cannot be null")
        }
        return CameraQrCodeView(context,methodChannel)
    }

}