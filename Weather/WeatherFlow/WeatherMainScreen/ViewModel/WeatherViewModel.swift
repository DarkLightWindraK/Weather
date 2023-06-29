import Foundation
import Moya
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    @Published var currentCity: String?
    @Published var currentWeather: WeatherModel?
    @Published var hourlyForecast: [HourForecastModel] = []
    @Published var status: Status = .loading
    
    private let locationService = ServicesAssembly.shared.resolve(LocationService.self)
    private let weatherService = ServicesAssembly.shared.resolve(WeatherService.self)
    private var cancellables = Set<AnyCancellable>()
    
    func requestCurrentForecast() {
        guard let locationService else {
            fatalError("Dependence \(String(describing: LocationService.self)) not found")
        }
        
        locationService.getCurrentLocation { [weak self] location in
            self?.getWeatherByCoordinates(
                location: location,
                numberOfDays: 2
            )
        } onFailure: { [weak self] _ in
            self?.getWeatherByCity(
                city: Constants.defaultCity,
                numberOfDays: 2
            )
        }
    }
    
    func updateWeatherByCity(city: String) {
        status = .loading
        getWeatherByCity(city: city, numberOfDays: 2)
    }
}

private extension WeatherViewModel {
    
    enum Constants {
        static let defaultCity = "Moscow"
    }
    
    func getWeatherByCoordinates(
        location: CLLocation,
        numberOfDays: Int
    ) {
        guard let weatherService else { fatalError("Dependence \(String(describing: WeatherService.self)) not found") }
        
        weatherService
            .getShortForecastByCoordinates(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            .sink { status in
                switch status {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.currentCity = response?.location.city
                self?.currentWeather = response?.currentWeather
                self?.hourlyForecast = self?.weatherService?
                    .getRelevantForecast(
                        forecast: response?.nextFewHoursForecast ?? []
                    ) ?? []
                self?.status = .ready
            }
            .store(in: &cancellables)
    }
    
    func getWeatherByCity(
        city: String,
        numberOfDays: Int
    ) {
        guard let weatherService else { fatalError("Dependence \(String(describing: WeatherService.self)) not found") }
        
        weatherService
            .getShortForecastByCity(for: city)
            .sink { [weak self] status in
                switch status {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                self?.status = .fail
                }
            } receiveValue: { [weak self] response in
                self?.currentCity = response?.location.city
                self?.currentWeather = response?.currentWeather
                self?.hourlyForecast = self?.weatherService?
                    .getRelevantForecast(
                        forecast: response?.nextFewHoursForecast ?? []
                    ) ?? []
                self?.status = .ready
            }.store(in: &cancellables)
    }
}

extension WeatherViewModel {
    enum Status {
        case loading, ready, fail
    }
}
