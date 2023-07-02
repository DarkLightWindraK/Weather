import Foundation
import Swinject

class Assembly {
    static let shared = Assembly()
    private let container = Container()
    
    private init() {
        container.register(LocationService.self) { _ in
            LocationServiceImpl()
        }
        
        container.register(WeatherService.self) { _ in
            WeatherServiceImpl()
        }
        
        container.register(SessionStore.self) { _ in
            SessionStore()
        }
        
        container.register(WeatherViewModel.self) { resolver in
            WeatherViewModel(
                locationService: resolver.resolve(LocationService.self)!,
                weatherService: resolver.resolve(WeatherService.self)!
            )
        }
        
        container.register(CityPickerViewModel.self) { _ in
            CityPickerViewModel()
        }
    }
    
    func resolve<Service>() -> Service {
        guard let service = container.resolve(Service.self) else {
            fatalError("Cannot assembly for \(Service.self)")
        }
        
        return service
    }
}
