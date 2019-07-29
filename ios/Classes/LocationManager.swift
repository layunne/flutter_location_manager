//
//  LocationManager.swift
//  flutter_location_manager
//
//  Created by Fellype Macedo on 18/07/19.
//

import CoreLocation
import CoreData
import UIKit

@available(iOS 9.0, *)
class LocationManager : NSObject, CLLocationManagerDelegate {

    let locationManager: CLLocationManager = CLLocationManager()
    
    var updatesEnabled = false

    var locationCallback: ((_ location: Location)-> ())?

    override init () {

        super.init()
        
        self.locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        print(">>> Location Manager Instantiated")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(">>> init(coder:) has not been implemented")
    }
    
    func areUpdateEnabled() -> Bool {return self.updatesEnabled}

    func startUpdatingLocation (distanceFilter: Double, accuracy: Double) {
        print(">>> starting updating location")
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if (!self.updatesEnabled){
                
                self.locationManager.desiredAccuracy = accuracy //kCLLocationAccuracyBestForNavigation
                self.locationManager.distanceFilter = distanceFilter //kCLDistanceFilterNone
                
                self.locationManager.allowsBackgroundLocationUpdates = true
                
                self.locationManager.startUpdatingLocation()
                
                self.updatesEnabled = true;
                
                print(">>> started updating location")
                
            } else {
                print(">>> updating location already started")
            }
            
        } else {
            
            print(">>> Application is not authorized to use location")
            
        }
    }
    
    func requestLocation() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            self.locationManager.requestLocation()
        }
        else {
            print(">>> Application is not authorized to use location")
        }
        
    }
    
    func stopUpdatingLocation() {
        print(">>> stoping updating location")
        if(self.updatesEnabled) {
            
            self.updatesEnabled = false;
            self.locationManager.stopUpdatingLocation()
            
        } else {
            print(">>> location updating have not been started")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = Location(location: locations.last!)
    
        self.locationCallback?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(">>> Location update error: \(error.localizedDescription)")
    }
}
