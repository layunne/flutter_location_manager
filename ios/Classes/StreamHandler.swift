//
//  StreamHandler.swift
//  flutter_location_manager
//
//  Created by Fellype Macedo on 17/07/19.
//

import Flutter

class StreamHandler : NSObject, FlutterStreamHandler {
    
    var sink:FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        self.sink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print(">>> onCancel EventChannel")
        self.sink = nil
        return nil
    }
    
    func send(data: Any) {
        
        if let sink = self.sink {
            sink(data)
        } else {
            print(">>> no sink")
        }
    }
}
