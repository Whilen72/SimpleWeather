//
//  LocationService.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/6/20.
//

import Foundation
import CoreLocation
import RxSwift

protocol LocationServiceType {
    func startUpdatingLocation()
    var location: PublishSubject<CLLocation> { get }
    var locality: PublishSubject<String> { get }
}

class LocationService: NSObject, LocationServiceType {
    
    let location = PublishSubject<CLLocation>()
    let locality = PublishSubject<String>()
    
    private lazy var defaultLocation = CLLocation(latitude: 53.899049, longitude: 27.526119)
    private lazy var defaultLocality: String = "Minsk"
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        return locationManager
    }()
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        } else {
            location.onNext(defaultLocation)
            locality.onNext(defaultLocality)
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        location.onNext(userLocation)

        CLGeocoder().reverseGeocodeLocation(userLocation) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let placemark: CLPlacemark = placemarks?.first {
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                self.locality.onNext(placemark.locality ?? self.defaultLocality)
            } else {
                self.locality.onNext(self.defaultLocality)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {        
        location.onNext(defaultLocation)
        locality.onNext(defaultLocality)
    }
}
