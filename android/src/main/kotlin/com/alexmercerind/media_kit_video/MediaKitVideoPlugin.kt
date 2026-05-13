/*
 * This file is a part of media_kit (https://github.com/media-kit/media-kit).
 *
 * Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
 * All rights reserved.
 * Use of this source code is governed by MIT license that can be found in the LICENSE file.
 */
package com.alexmercerind.media_kit_video

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MediaKitVideoPlugin */
class MediaKitVideoPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var channel: MethodChannel? = null
    private var videoOutputManager: VideoOutputManager? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME).also {
            it.setMethodCallHandler(this)
            videoOutputManager = VideoOutputManager(it, binding.textureRegistry)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        videoOutputManager?.disposeAll()
        videoOutputManager = null
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "VideoOutputManager.Create" -> create(call, result)
            "VideoOutputManager.CreateSurface" -> createSurface(call, result)
            "VideoOutputManager.SetSurfaceTextureSize" -> setSurfaceTextureSize(call, result)
            "VideoOutputManager.Dispose" -> dispose(call, result)
            "Utils.IsEmulator" -> result.success(Utils.isEmulator())
            else -> result.notImplemented()
        }
    }

    private fun create(call: MethodCall, result: Result) {
        val handle = call.longArgument("handle")
        if (handle == null) {
            result.success(null)
            return
        }
        val manager = requireVideoOutputManager(result) ?: return
        result.success(mapOf("id" to manager.create(handle).id))
    }

    private fun createSurface(call: MethodCall, result: Result) {
        val handle = call.longArgument("handle")
        if (handle == null) {
            result.success(null)
            return
        }
        val manager = requireVideoOutputManager(result) ?: return
        result.success(mapOf("wid" to manager.createSurface(handle)))
    }

    private fun setSurfaceTextureSize(call: MethodCall, result: Result) {
        val handle = call.longArgument("handle")
        val width = call.intArgument("width")
        val height = call.intArgument("height")
        if (handle != null && width != null && height != null) {
            val manager = requireVideoOutputManager(result) ?: return
            manager.setSurfaceTextureSize(handle, width, height)
        }
        result.success(null)
    }

    private fun dispose(call: MethodCall, result: Result) {
        val handle = call.longArgument("handle")
        if (handle != null) {
            val manager = requireVideoOutputManager(result) ?: return
            manager.dispose(handle)
        }
        result.success(null)
    }

    private fun requireVideoOutputManager(result: Result): VideoOutputManager? {
        val manager = videoOutputManager
        if (manager == null) {
            result.error(
                "media_kit_video_not_attached",
                "MediaKitVideoPlugin is not attached to a Flutter engine.",
                null,
            )
        }
        return manager
    }

    private fun MethodCall.longArgument(name: String): Long? =
        argument<Any>(name)?.let { value ->
            when (value) {
                is Long -> value
                is Int -> value.toLong()
                is String -> value.toLongOrNull()
                else -> null
            }
        }

    private fun MethodCall.intArgument(name: String): Int? =
        argument<Any>(name)?.let { value ->
            when (value) {
                is Int -> value
                is Long -> value.toInt()
                is String -> value.toIntOrNull()
                else -> null
            }
        }

    companion object {
        private const val CHANNEL_NAME = "com.alexmercerind/media_kit_video"

        @JvmStatic
        var activity: Activity? = null
            private set
    }
}
