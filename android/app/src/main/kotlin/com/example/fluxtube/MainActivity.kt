package com.fazilvk.fluxtube

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.fazilvk.fluxtube.newpipe.NewPipeMethodHandler

class MainActivity: FlutterActivity() {
    companion object {
        private const val NEWPIPE_CHANNEL = "com.fazilvk.fluxtube/newpipe"
    }

    private var newPipeHandler: NewPipeMethodHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize NewPipe method handler
        newPipeHandler = NewPipeMethodHandler()

        // Register NewPipe method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NEWPIPE_CHANNEL)
            .setMethodCallHandler(newPipeHandler)
    }

    override fun onDestroy() {
        newPipeHandler?.dispose()
        super.onDestroy()
    }
}
