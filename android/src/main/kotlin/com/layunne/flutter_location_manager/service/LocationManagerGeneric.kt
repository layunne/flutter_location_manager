package com.layunne.flutter_location_manager.service

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Looper
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.layunne.flutter_location_manager.Permission
import com.layunne.flutter_location_manager.models.LocationData
import io.flutter.plugin.common.MethodChannel

data class Error(val code: String, val message: String)

class LocationManagerGeneric(private val activity: Activity){

    private val permissionNotDeterminedErr = Error("PERMISSION_NOT_DETERMINED", "Location must be determined, call request permission before calling location")
    private val permissionDeniedErr = Error("PERMISSION_DENIED", "You are not allow to access location")

    private val locationManager: LocationManager = activity.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    private val fusedLocationClient = FusedLocationProviderClient(activity)

    private val locationRequest = LocationRequest()

    private var permission: String = Permission.NOT_DETERMINED

    private var permissionRequested = false

    private val requestCode = 22

    init {
        locationRequest.interval = 10000
        locationRequest.fastestInterval = 10000 / 2
        locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY

        requestPermissions()
    }

    private var locationCallback: LocationCallback? = null

    fun startUpdatingLocation(result: (data: Any) -> Unit){

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                result(LocationData(locationResult.lastLocation).toJson())
            }
        }

        fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.myLooper())
    }

    fun stopUpdatingLocation(){
        if(locationCallback != null){
            fusedLocationClient.removeLocationUpdates(locationCallback)
        }

    }

    fun getCurrentPosition(result: MethodChannel.Result){
        requestPermissions()
        when (permission) {
            Permission.NOT_DETERMINED -> result.error(permissionNotDeterminedErr.code, permissionNotDeterminedErr.message, null)
            Permission.DENIED -> result.error(permissionDeniedErr.code, permissionDeniedErr.message, null)
            Permission.AUTHORIZED -> fusedLocationClient.lastLocation.addOnSuccessListener { location ->
                result.success(LocationData(location).toJson())
            }
        }
    }

    private fun requestPermissions() {
        if(permission == Permission.AUTHORIZED) return

        println("🔴 requestPermissions")
        val currentPermission = ActivityCompat.checkSelfPermission(activity,  Manifest.permission.ACCESS_FINE_LOCATION)

        println("currentPermission: $currentPermission")
        if(currentPermission == PackageManager.PERMISSION_GRANTED){
            permissionRequested = true
            permission = Permission.AUTHORIZED
        }
        else if (currentPermission == PackageManager.PERMISSION_DENIED) {
            if (!permissionRequested) {
                permissionRequested = true
                permission = Permission.NOT_DETERMINED
                ActivityCompat.requestPermissions(activity, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), requestCode)
            }
        }
    }

    fun isGPSEnabled(): Boolean {

        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }
}