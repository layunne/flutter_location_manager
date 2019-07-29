package com.layunne.flutter_location_manager.models

import android.location.Location
import org.json.JSONObject

data class LocationData(
        val latitude: Double,
        val longitude: Double,
        val timestamp: Long,
        val speed: Float,
        val accuracy: Float,
        val altitude: Double
) {
    constructor(location: Location):
            this(
                    location.latitude,
                    location.longitude,
                    location.time,
                    location.speed,
                    location.accuracy,
                    location.altitude
            )

    fun toJson() : String {
        val json = JSONObject()
        json.put("latitude", this.latitude)
        json.put("longitude", this.longitude)
        json.put("timestamp", this.timestamp)
        json.put("accuracy", this.accuracy)
        json.put("altitude", this.altitude)
        json.put("speed", this.speed)

        return json.toString()
    }
}