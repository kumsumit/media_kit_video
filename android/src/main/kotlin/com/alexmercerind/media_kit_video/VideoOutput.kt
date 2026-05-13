/*
 * This file is a part of media_kit (https://github.com/media-kit/media-kit).
 *
 * Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
 * All rights reserved.
 * Use of this source code is governed by MIT license that can be found in the LICENSE file.
 */
package com.alexmercerind.media_kit_video

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.PorterDuff
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Surface
import android.view.View
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterJNI
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import java.lang.reflect.Method
import java.util.Locale

internal class VideoOutput(
    private val handle: Long,
    private val channel: MethodChannel,
    textureRegistry: TextureRegistry,
) {
    var id: Long = 0
        private set

    private var wid: Long = 0
    private var surface: Surface? = null
    private val surfaceTextureEntry = textureRegistry.createSurfaceTexture()
    private val lock = Any()
    private var firstFrameRendered = false

    private val newGlobalObjectRef: Method
    private val deleteGlobalObjectRef: Method

    init {
        try {
            val helperClass =
                Class.forName("com.alexmercerind.mediakitandroidhelper.MediaKitAndroidHelper")
            newGlobalObjectRef = helperClass.getDeclaredMethod("newGlobalObjectRef", Object::class.java)
            deleteGlobalObjectRef = helperClass.getDeclaredMethod("deleteGlobalObjectRef", Long::class.javaPrimitiveType)
            newGlobalObjectRef.isAccessible = true
            deleteGlobalObjectRef.isAccessible = true
        } catch (e: Throwable) {
            Log.i(
                TAG,
                "package:media_kit_libs_android_video missing. Make sure you have added it to pubspec.yaml.",
            )
            throw RuntimeException(
                "Failed to initialize com.alexmercerind.media_kit_video.VideoOutput.",
                e,
            )
        }

        id = surfaceTextureEntry.id()
        Log.i(TAG, String.format(Locale.ENGLISH, "$CLASS_NAME: id = %d", id))

        val flutterJNIAvailable = getFlutterJNIReference() != null
        Log.i(TAG, String.format(Locale.ENGLISH, "flutterJNIAPIAvailable = %b", flutterJNIAvailable))

        if (flutterJNIAvailable) {
            registerFrameListener()
        } else {
            notifyFirstFrameRendered(includeTextureIds = true)
        }
    }

    fun dispose() {
        try {
            surfaceTextureEntry.release()
        } catch (e: Throwable) {
            e.printStackTrace()
        }

        try {
            surface?.release()
            surface = null
        } catch (e: Throwable) {
            e.printStackTrace()
        }

        val widToDelete = wid
        if (widToDelete == 0L) {
            return
        }
        wid = 0

        try {
            Handler(Looper.getMainLooper()).postDelayed(
                {
                    try {
                        // Invoke DeleteGlobalRef after a voluntary delay to eliminate possibility of libmpv referencing it sometime in the near future.
                        deleteGlobalObjectRef.invoke(null, widToDelete)
                        Log.i(
                            TAG,
                            String.format(
                                Locale.ENGLISH,
                                "com.alexmercerind.mediakitandroidhelper.MediaKitAndroidHelper.deleteGlobalObjectRef: %d",
                                widToDelete,
                            ),
                        )
                    } catch (e: Throwable) {
                        e.printStackTrace()
                    }
                },
                DELETE_GLOBAL_REF_DELAY_MS,
            )
        } catch (e: Throwable) {
            e.printStackTrace()
        }
    }

    fun createSurface(): Long =
        synchronized(lock) {
            releaseSurface(deleteGlobalReferenceImmediately = true)
            try {
                surface = Surface(surfaceTextureEntry.surfaceTexture())
                wid = newGlobalObjectRef.invoke(null, surface) as Long
            } catch (e: Throwable) {
                e.printStackTrace()
                wid = 0
            }
            wid
        }

    fun setSurfaceTextureSize(width: Int, height: Int) {
        try {
            surfaceTextureEntry.surfaceTexture().setDefaultBufferSize(width, height)
        } catch (e: Throwable) {
            e.printStackTrace()
        }
    }

    private fun registerFrameListener() {
        val listener: (android.graphics.SurfaceTexture) -> Unit = {
            synchronized(lock) {
                try {
                    notifyFirstFrameRendered(includeTextureIds = false)
                    getFlutterJNIReference()?.markTextureFrameAvailable(id)
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            surfaceTextureEntry
                .surfaceTexture()
                .setOnFrameAvailableListener(listener, Handler(Looper.getMainLooper()))
        } else {
            @Suppress("DEPRECATION")
            surfaceTextureEntry.surfaceTexture().setOnFrameAvailableListener(listener)
        }
    }

    private fun notifyFirstFrameRendered(includeTextureIds: Boolean) {
        if (firstFrameRendered) {
            return
        }
        firstFrameRendered = true

        val data = mutableMapOf<String, Any>("handle" to handle)
        if (includeTextureIds) {
            data["id"] = id
            data["wid"] = wid
        }
        channel.invokeMethod("VideoOutput.WaitUntilFirstFrameRenderedNotify", data)
        Log.i(
            TAG,
            String.format(
                Locale.ENGLISH,
                "VideoOutput.WaitUntilFirstFrameRenderedNotify = %d",
                handle,
            ),
        )
    }

    private fun releaseSurface(deleteGlobalReferenceImmediately: Boolean) {
        try {
            surface?.let {
                clearSurface(it)
                it.release()
            }
            surface = null
        } catch (e: Throwable) {
            e.printStackTrace()
        }

        if (deleteGlobalReferenceImmediately && wid != 0L) {
            try {
                deleteGlobalObjectRef.invoke(null, wid)
            } catch (e: Throwable) {
                e.printStackTrace()
            } finally {
                wid = 0
            }
        }
    }

    private fun clearSurface(surface: Surface) {
        var canvas: Canvas? = null
        try {
            canvas = surface.lockCanvas(null)
            canvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR)
        } catch (e: Throwable) {
            e.printStackTrace()
        } finally {
            if (canvas != null) {
                try {
                    surface.unlockCanvasAndPost(canvas)
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }
        }
    }

    private fun getFlutterJNIReference(): FlutterJNI? {
        val activity = MediaKitVideoPlugin.activity ?: return null
        return try {
            val view =
                activity.findViewById<FlutterView>(FlutterActivity.FLUTTER_VIEW_ID)
                    ?: activity
                        .findViewById<FrameLayout>(FlutterFragmentActivity.FRAGMENT_CONTAINER_ID)
                        ?.findFlutterView()
                    ?: return null
            val engine = view.attachedFlutterEngine ?: return null
            val field = FlutterEngine::class.java.getDeclaredField("flutterJNI")
            field.isAccessible = true
            field.get(engine) as? FlutterJNI
        } catch (e: Throwable) {
            e.printStackTrace()
            null
        }
    }

    private fun FrameLayout.findFlutterView(): FlutterView? {
        for (i in 0 until childCount) {
            val child: View = getChildAt(i)
            if (child is FlutterView) {
                return child
            }
        }
        return null
    }

    companion object {
        private const val TAG = "media_kit"
        private const val CLASS_NAME = "com.alexmercerind.media_kit_video.VideoOutput"
        private const val DELETE_GLOBAL_REF_DELAY_MS = 5000L
    }
}
