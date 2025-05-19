package com.example.xverifydemoapp.platforms

import android.content.Context
import android.util.Log
import com.example.xverifydemoapp.utils.BusinessType
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import com.example.xverifydemoapp.utils.ONBOARDDATAMANAGER
import com.example.xverifydemoapp.views.CameraMrzView


class CameraMrzFactory(private val methodChannel: MethodChannel?): PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        if (context == null) {
            throw IllegalArgumentException("Context cannot be null")
        }
        try{
            val map:Map<String,Any> = args as Map<String, Any>
            val business = map["business"] as String
            ONBOARDDATAMANAGER.businessType = BusinessType.valueOf(business)
        }catch (e:Exception){
            Log.e("CameraMrzFactory", "Fail: ${e.message}")
        }
        return CameraMrzView(context,methodChannel)
    }

}