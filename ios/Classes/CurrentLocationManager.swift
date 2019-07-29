//
//  CurrentLocationManager.swift
//  flutter_location_manager
//
//  Created by Fellype Macedo on 22/07/19.
//
import CoreLocation

@available(iOS 9.0, *)
class CurrentLocationManager : LocationManager {

    override init () {
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCurrentePosition() {
        print("🔴 getCurrentePosition")
        super.startUpdatingLocation(distanceFilter: kCLDistanceFilterNone, accuracy: kCLLocationAccuracyBestForNavigation)
//        super.requestLocation()
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        super.locationManager(manager, didUpdateLocations: locations)
        super.stopUpdatingLocation()
    }
}

