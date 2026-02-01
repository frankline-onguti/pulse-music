package com.example.pulse_music

import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "pulse/music_scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "scanMusic") {
                result.success(scanMusic())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun scanMusic(): List<Map<String, Any>> {
        val songs = mutableListOf<Map<String, Any>>()

        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.DURATION
        )

        val cursor = contentResolver.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            MediaStore.Audio.Media.IS_MUSIC + "!= 0",
            null,
            null
        )

        cursor?.use {
            val idCol = it.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
            val titleCol = it.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val artistCol = it.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)
            val albumCol = it.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM)
            val pathCol = it.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
            val durationCol = it.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)

            while (it.moveToNext()) {
                songs.add(
                    mapOf(
                        "id" to it.getString(idCol),
                        "title" to it.getString(titleCol),
                        "artist" to it.getString(artistCol),
                        "album" to it.getString(albumCol),
                        "path" to it.getString(pathCol),
                        "duration" to it.getLong(durationCol)
                    )
                )
            }
        }

        return songs
    }
}
