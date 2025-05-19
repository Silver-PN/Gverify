package com.example.xverifydemoapp.utils

import android.content.Context
import android.content.ContextWrapper
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.core.util.Consumer
import androidx.lifecycle.LifecycleOwner
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.io.IOException

object Utils {
    fun storeImageEid(context: Context, bitmap: Bitmap?, callback: Consumer<String>) {
        val pictureFile = File(context.cacheDir.path + File.separator + "IMAGE_EID_" + System.currentTimeMillis() + ".jpg")
        if (!pictureFile.exists()) {
            if (bitmap == null) {
                return
            }
            try {
                val fos = FileOutputStream(pictureFile)
                bitmap.compress(Bitmap.CompressFormat.JPEG, 90, fos)
                fos.close()
                callback.accept(pictureFile.path)
            } catch (_: FileNotFoundException) {

            } catch (_: IOException) {

            }
        } else {
            callback.accept(pictureFile.path)
        }
    }

    fun isAvailedImageEid(context: Context) : Bitmap? {
        val dir = context.cacheDir
        var fileLastModified: File? = null
        if (dir != null && dir.isDirectory) {
            dir.list()?.forEach {
                if (it.startsWith("IMAGE_EID_")) {
                    val file = File(context.cacheDir.path + File.separator + it)
                    if (fileLastModified == null || file.lastModified() > fileLastModified!!.lastModified()) {
                        fileLastModified = file
                    }
                }
            }
        }

        if (fileLastModified == null) {
            return null
        }
        return if (fileLastModified!!.exists()) {
            BitmapFactory.decodeFile(fileLastModified!!.absolutePath)
        } else {
            null
        }
    }

    fun isAvailedGetPathImageEid(context: Context) : String? {
        val dir = context.cacheDir
        var fileLastModified: File? = null
        if (dir != null && dir.isDirectory) {
            dir.list()?.forEach {
                if (it.startsWith("IMAGE_EID_")) {
                    val file = File(context.cacheDir.path + File.separator + it)
                    if (fileLastModified == null || file.lastModified() > fileLastModified!!.lastModified()) {
                        fileLastModified = file
                    }
                }
            }
        }

        if (fileLastModified == null) {
            return null
        }
        return if (fileLastModified!!.exists()) {
            return fileLastModified!!.absolutePath
        } else {
            null
        }
    }

    fun getLifecycleOwner(context: Context): LifecycleOwner? {
        var currentContext = context
        while (currentContext is ContextWrapper) {
            if (currentContext is LifecycleOwner) {
                return currentContext
            }
            currentContext = currentContext.baseContext
        }
        return null
    }

}