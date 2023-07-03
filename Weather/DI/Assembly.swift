import Swinject
import Moya

class Assembly {
    static let shared = Assembly()
    private let container = makeContainer()
    
    func resolve<Service>() -> Service {
        guard let service = container.resolve(Service.self) else {
            fatalError("Cannot assembly for \(Service.self)")
        }
        
        return service
    }
}

private func makeContainer() -> Container {
    let container = Container()
    
    container.register(LocationService.self) { _ in
        LocationServiceImpl()
    }.inObjectScope(.container)
    
    container.register(WeatherService.self) { _ in
        WeatherServiceImpl()
    }.inObjectScope(.container)
    
    container.register(SessionStore.self) { _ in
        SessionStore()
    }.inObjectScope(.container)
    
    container.register(MoyaProvider<WeatherAPI>.self) { _ in
        MoyaProvider<WeatherAPI>()
    }.inObjectScope(.container)
    
    container.register(LoginViewModel.self) { resolver in
        LoginViewModel(
            sessionStore: resolver.resolve(SessionStore.self)!
        )
    }.inObjectScope(.container)
    
    container.register(WeatherViewModel.self) { resolver in
        WeatherViewModel(
            locationService: resolver.resolve(LocationService.self)!,
            weatherService: resolver.resolve(WeatherService.self)!
        )
    }.inObjectScope(.container)
    
    container.register(WeatherDetailsViewModel.self) { resolver in
        WeatherDetailsViewModel(
            locationService: resolver.resolve(LocationService.self)!,
            weatherService: resolver.resolve(WeatherService.self)!
        )
    }.inObjectScope(.container)
    
    container.register(CityPickerViewModel.self) { _ in
        CityPickerViewModel()
    }.inObjectScope(.container)
    
    return container
}
