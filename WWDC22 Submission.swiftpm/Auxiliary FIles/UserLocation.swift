//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation
import CoreLocation

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getUserLocation() -> Location? {
        
        guard let locationManager = locationManager else {
            return nil
        }
        
        guard let location = locationManager.location else {
            return nil
        }

        return Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
}
