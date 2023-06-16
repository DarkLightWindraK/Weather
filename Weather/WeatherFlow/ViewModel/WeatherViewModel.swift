import Foundation
import Moya
import Combine

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    func getCurrentWeather(
        latitude: Double,
        longitude: Double
    ) {
        weatherService.getCurrentWeather(
            latitude: latitude,
            longitude: longitude
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case let .failure(error):
                print(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] response in
            self?.currentWeather = response
        }.store(in: &cancellables)
    }
}
