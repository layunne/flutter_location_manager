//
//  StreamLocationManager.swift
//  flutter_location_manager
//
//  Created by Fellype Macedo on 22/07/19.
//

import CoreLocation

@available(iOS 9.0, *)
class StreamLocationManager : LocationManager {
    
    override init () {
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func streamCurrentePosition(distanceFilter: Double, accuracy: Double) {
        
        super.startUpdatingLocation(distanceFilter: distanceFilter, accuracy: accuracy)
    }
}


