/*
 * This file is a part of media_kit (https://github.com/media-kit/media-kit).
 *
 * Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
 * All rights reserved.
 * Use of this source code is governed by MIT license that can be found in the LICENSE file.
 */
package com.alexmercerind.media_kit_video

import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import java.util.Locale

internal class VideoOutputManager(
    private val channel: MethodChannel,
    private val textureRegistry: TextureRegistry,
) {
    private val videoOutputs = mutableMapOf<Long, VideoOutput>()
    private val lock = Any()

    fun create(handle: Long): VideoOutput =
        synchronized(lock) {
            Log.i(TAG, String.format(Locale.ENGLISH, "$CLASS_NAME.create: %d", handle))
            videoOutputs.getOrPut(handle) {
                VideoOutput(handle, channel, textureRegistry)
            }
        }

    fun dispose(handle: Long) {
        synchronized(lock) {
            Log.i(TAG, String.format(Locale.ENGLISH, "$CLASS_NAME.dispose: %d", handle))
            videoOutputs.remove(handle)?.dispose()
        }
    }

    fun disposeAll() {
        synchronized(lock) {
            videoOutputs.values.forEach { it.dispose() }
            videoOutputs.clear()
        }
    }

    fun createSurface(handle: Long): Long =
        synchronized(lock) {
            Log.i(TAG, String.format(Locale.ENGLISH, "$CLASS_NAME.createSurface: %d", handle))
            videoOutputs[handle]?.createSurface() ?: 0L
        }

    fun setSurfaceTextureSize(handle: Long, width: Int, height: Int) {
        synchronized(lock) {
            Log.i(
                TAG,
                String.format(
                    Locale.ENGLISH,
                    "$CLASS_NAME.setSurfaceTextureSize: %d %d %d",
                    handle,
                    width,
                    height,
                ),
            )
            videoOutputs[handle]?.setSurfaceTextureSize(width, height)
        }
    }

    companion object {
        private const val TAG = "media_kit"
        private const val CLASS_NAME =
            "com.alexmercerind.media_kit_video.VideoOutputManager"
    }
}
