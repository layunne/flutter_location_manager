import Flutter
import UIKit
import CoreLocation

enum ChannelName {
    static let location: String = "flutter_location_manager/location"
}

@available(iOS 9.0, *)
public class SwiftFlutterLocationManagerPlugin: NSObject, FlutterPlugin {
//    var eventLocationChannel:FlutterEventChannel?
    var eventLocationStreamHandler = StreamHandler()
    var currentLocationManager = CurrentLocationManager()
    
    var streamLocationManager = StreamLocationManager()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_location_manager", binaryMessenger: registrar.messenger())
        
        let instance = SwiftFlutterLocationManagerPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.eventChannelRegister(registrar)
        
        registrar.addApplicationDelegate(instance)
    }
    
    func eventChannelRegister(_ registrar: FlutterPluginRegistrar) {
        
        // Stream setup
        FlutterEventChannel(name: ChannelName.location, binaryMessenger: registrar.messenger())
            .setStreamHandler(eventLocationStreamHandler)

    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        if (call.method == "getPlatformVersion") {
            
            result("iOS " + UIDevice.current.systemVersion)
        }
        else if(call.method == "getCurrentPosition"){
            
            func resultHander(location: Location) -> Void{
                result(location.toJson())
            }
            
            currentLocationManager.locationCallback = resultHander
            
            currentLocationManager.getCurrentePosition()
        }
            
        else if(call.method == "startUpdatingLocation"){
            
            var distanceFilter = kCLDistanceFilterNone
            var accuracy = kCLLocationAccuracyBestForNavigation
            print("args: \(String(describing: call.arguments))")
            if let args = call.arguments as? [String: Any],
                let distanceFilterArg =  args["distanceFilter"] as? Double,
                let accuracyArg = args["accuracy"] as? Double{
                distanceFilter = distanceFilterArg
                accuracy = accuracyArg
            }
            
            print(">>> distanceFilter: \(distanceFilter) | accuracy: \(accuracy)")
            func resultHander(location: Location) -> Void{
                self.eventLocationStreamHandler.send(data: location.toJson())
            }
            
            streamLocationManager.locationCallback = resultHander
            
            streamLocationManager.streamCurrentePosition(distanceFilter: distanceFilter, accuracy: accuracy)
            
            result("started")
        }
            
        else if(call.method == "stopUpdatingLocation"){
            
            streamLocationManager.stopUpdatingLocation()
            
            result("stopped")
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    }
}
