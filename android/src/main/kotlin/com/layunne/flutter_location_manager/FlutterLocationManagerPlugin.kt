package com.layunne.flutter_location_manager

import com.layunne.flutter_location_manager.models.MyStreamHandler
import com.layunne.flutter_location_manager.service.LocationManagerGeneric
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class ChannelName {
  companion object {
    const val LOCATION = "flutter_location_manager/location"
  }
}

class MethodName {
  companion object {
    const val PLATFORM_VERSION = "getPlatformVersion"
    const val CURRENT_POSITION = "getCurrentPosition"
    const val START_UPDATING_LOCATION = "startUpdatingLocation"
    const val STOP_UPDATING_LOCATION = "stopUpdatingLocation"
  }
}

class Permission {
  companion object {
    const val NOT_DETERMINED = "NOT_DETERMINED"
    const val DENIED = "DENIED"
    const val AUTHORIZED = "AUTHORIZED"
  }
}

data class Error(val code: String, val message: String)




class FlutterLocationManagerPlugin(registrar: Registrar): MethodCallHandler {


  private val eventLocationStreamHandler = MyStreamHandler()

  private val locationManagerGeneric = LocationManagerGeneric(registrar.activity())

  init {
    val channel = MethodChannel(registrar.messenger(), "flutter_location_manager")

    val event = EventChannel(registrar.messenger(), ChannelName.LOCATION)

    channel.setMethodCallHandler(this)

    event.setStreamHandler(eventLocationStreamHandler)
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {

      FlutterLocationManagerPlugin(registrar)

    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        MethodName.PLATFORM_VERSION -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
        MethodName.CURRENT_POSITION -> locationManagerGeneric.getCurrentPosition(result)
        MethodName.START_UPDATING_LOCATION -> {result.success("ok");locationManagerGeneric.startUpdatingLocation(eventLocationStreamHandler::send, call.argument<Double>("distanceFilter")?.toFloat()?:0f)}
        MethodName.STOP_UPDATING_LOCATION -> locationManagerGeneric.stopUpdatingLocation()
        else -> result.notImplemented()
    }
  }
}
