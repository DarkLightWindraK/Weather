import Foundation
import CoreLocation

protocol LocationService {
    func requestCurrentLocation(
        onLocationReceived: ((CLLocation) -> Void)?,
        onFailure: ((Error) -> Void)?
    )
    func getLastSavedLocation() -> CLLocation?
}

class LocationServiceImpl: NSObject, LocationService {
    private let manager = CLLocationManager()
    private let storage = UserDefaults.standard
    private var onLocationReceived: ((CLLocation) -> Void)?
    private var onFailure: ((Error) -> Void)?
    
    override init() {
        super.init()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
    }
    
    func requestCurrentLocation(
        onLocationReceived: ((CLLocation) -> Void)?,
        onFailure: ((Error) -> Void)?
    ) {
        self.onLocationReceived = onLocationReceived
        self.onFailure = onFailure
        
        manager.requestWhenInUseAuthorization()
    }
    
    func getLastSavedLocation() -> CLLocation? {
        let dict = storage.dictionary(forKey: Constants.locationKey)
        if
            let dict = dict,
            let latitude = dict["latitude"] as? Double,
            let longitude = dict["longitude"] as? Double
        {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        
        return nil
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
            saveLocation(location: location)
            onLocationReceived?(location)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onFailure?(error)
    }
}

private extension LocationServiceImpl {
    
    func saveLocation(location: CLLocation) {
        let dict: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        storage.set(dict, forKey: Constants.locationKey)
    }
    
    enum Constants {
        static let locationKey = "last_location"
    }
}

private enum LocationError: Error {
    case userBlockedLocation
}
