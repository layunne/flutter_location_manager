//
//  LocationData.swift
//  flutter_location_manager
//
//  Created by Fellype Macedo on 18/07/19.
//

import Foundation
import CoreLocation

struct Location : Codable{
    
    let latitude : Double
    let longitude: Double
    let timestamp: Double
    let speed: Double
    let accuracy: Double
    let altitude: Double
    
    init(location: CLLocation){
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = location.timestamp.timeIntervalSince1970
        self.speed = location.speed
        self.accuracy = location.horizontalAccuracy
        self.altitude = location.altitude
    }
    
    func toJson() -> String{
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        return String(data: jsonData!, encoding: String.Encoding.utf8) ?? ""
    }
}

