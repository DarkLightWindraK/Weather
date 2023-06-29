import Foundation
import MapKit

class CityPickerViewModel: ObservableObject {
    
    @Published var cities: [CityModel] = []
    
    func searchCityByRequest(text: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = MKCoordinateRegion(.world)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            guard
                let response = response,
                error == nil
            else {
                return
            }
            
            self?.cities = response.mapItems.map({ item in
                CityModel(
                    name: item.placemark.locality ?? "",
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude
                )
            })
        }
    }
}
