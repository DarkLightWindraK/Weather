import Foundation
import CoreLocation

protocol LocationService {
    func getCurrentLocation(
        onLocationReceived: ((CLLocation) -> Void)?,
        onFailure: ((Error) -> Void)?
    )
}

class LocationServiceImpl: NSObject, LocationService {
    private let manager = CLLocationManager()
    private var onLocationReceived: ((CLLocation) -> Void)?
    private var onFailure: ((Error) -> Void)?
    
    override init() {
        super.init()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
    }
    
    func getCurrentLocation(
        onLocationReceived: ((CLLocation) -> Void)?,
        onFailure: ((Error) -> Void)?
    ) {
        self.onLocationReceived = onLocationReceived
        self.onFailure = onFailure
        
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            onFailure?(LocationError.userBlockedLocation)
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            onLocationReceived?(location)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onFailure?(error)
    }
}

private enum LocationError: Error {
    case userBlockedLocation
}
