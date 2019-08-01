package com.layunne.flutter_location_manager.models

import io.flutter.plugin.common.EventChannel

class MyStreamHandler(onCancelCallback: () -> Unit) : EventChannel.StreamHandler {

    private var sink: EventChannel.EventSink? = null

    private val onCancelCallback = onCancelCallback

    override fun onListen(arguments: Any, eventSink: EventChannel.EventSink) {
        println("🔴 onListen")
        this.sink = eventSink
    }

    override fun onCancel(arguments: Any) {
        println(">>> onCancel EventChannel")
        this.sink = null
        onCancelCallback()
    }

    fun send(data: Any){
        if (this.sink != null) {
            try {
                sink!!.success(data)
            }catch (e: Exception){
                println(e.message)
                println(">>> no sink")
            }

        } else {
            println(">>> no sink")
        }
    }
}
