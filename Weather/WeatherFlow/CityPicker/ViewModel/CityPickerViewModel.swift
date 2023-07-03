import Foundation
import MapKit

class CityPickerViewModel: ObservableObject {
    
    @Published var cities: [CityModel] = []
    private var workItem: DispatchWorkItem?
    
    func searchCityByRequest(text: String) {
        workItem?.cancel()
        cities = []
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = MKCoordinateRegion(.world)
        
        let search = MKLocalSearch(request: searchRequest)
        
        workItem = DispatchWorkItem(block: {
            search.start { [weak self] response, error in
                guard
                    let response = response,
                    error == nil
                else {
                    return
                }
                
                self?.cities = response.mapItems.map({ item in
                    CityModel(
                        name: item.placemark.title ?? "",
                        latitude: item.placemark.coordinate.latitude,
                        longitude: item.placemark.coordinate.longitude
                    )
                })
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem!)
    }
}
