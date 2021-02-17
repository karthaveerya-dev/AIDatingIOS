//
//  LocationService.swift
//  Blindee
//
//  Created by Mihail Konoplitskyi on 6/9/19.
//  Copyright © 2019 4K-SOFT. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func didUpdateLocation()
}

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    var longtitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    var locationManager = CLLocationManager()
    var locationString = ""
    
    weak var delegate: LocationServiceDelegate?
    
    private override init() {
        super.init()
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestWhenInUseAuthorization()
        } else{
            locationManager.startUpdatingLocation()
        }
    }
    
    func getLocationString(lat: Double, lon: Double, success: @escaping (String) -> ()) {
        var locationString = ""
        let location = CLLocation(latitude: lat, longitude: lon)
        
        let ceo = CLGeocoder()
        ceo.reverseGeocodeLocation(location) { (placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            
            guard let placemarks = placemarks else {
                return
            }
            
            if placemarks.count > 0 {
                let placemark = placemarks[0]
                
                if let country = placemark.country {
                    locationString = locationString + country
                }
                
                if let locality = placemark.locality {
                    locationString = locationString + ", " + locality
                }
                
                if let subLocality = placemark.subLocality {
                    locationString = locationString + ", " + subLocality
                }
                
                success(locationString)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        latitude = userLocation.coordinate.latitude
        longtitude = userLocation.coordinate.longitude
        
        print("user latitude = \(latitude ?? 0)")
        print("user longitude = \(longtitude ?? 0)")
        
        let ceo = CLGeocoder()
        ceo.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            
            guard let placemarks = placemarks else {
                return
            }
            
            if placemarks.count > 0 {
                let placemark = placemarks[0]

                var addressString: String = ""
                if let country = placemark.country {
                    addressString = addressString + country
                }
                
                if let locality = placemark.locality {
                    addressString = addressString + ", " + locality
                }
                
                if let subLocality = placemark.subLocality {
                    addressString = addressString + ", " + subLocality
                }
    
                self.locationString = addressString
            }
        }
        
        manager.stopUpdatingLocation()
        
        delegate?.didUpdateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        print("Error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            debugPrint("Denied access for location service")
            break
        default:
            locationManager.startUpdatingLocation()
        }
    }
}
