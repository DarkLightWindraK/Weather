import Foundation
import Swinject

class ServicesAssembly {
    static var shared: Container {
        let container = Container()
        
        container.register(LocationService.self) { _ in
            LocationServiceImpl()
        }
        
        container.register(WeatherService.self) { _ in
            WeatherServiceImpl()
        }
        
        return container
    }
    
}
