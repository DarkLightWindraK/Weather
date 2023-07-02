import Foundation
import Swinject

class Assembly {
    static let shared = Assembly()
    private let container = Container()
    
    private init() {
        container.register(LocationService.self) { _ in
            LocationServiceImpl()
        }.inObjectScope(.container)
        
        container.register(WeatherService.self) { _ in
            WeatherServiceImpl()
        }.inObjectScope(.container)
        
        container.register(SessionStore.self) { _ in
            SessionStore()
        }.inObjectScope(.container)
        
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel(sessionStore: resolver.resolve(SessionStore.self)!)
        }.inObjectScope(.container)
        
        container.register(WeatherViewModel.self) { resolver in
            WeatherViewModel(
                locationService: resolver.resolve(LocationService.self)!,
                weatherService: resolver.resolve(WeatherService.self)!
            )
        }.inObjectScope(.container)
        
        container.register(CityPickerViewModel.self) { _ in
            CityPickerViewModel()
        }.inObjectScope(.container)
    }
    
    func resolve<Service>() -> Service {
        guard let service = container.resolve(Service.self) else {
            fatalError("Cannot assembly for \(Service.self)")
        }
        
        return service
    }
}
