import Foundation
import Moya
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    @Published var currentLocation: LocationModel?
    @Published var currentWeather: WeatherModel?
    @Published var hourlyForecast: [HourForecastModel] = []
    @Published var status: Status = .loading
    
    private let locationService: LocationService
    private let weatherService: WeatherService
    private var cancellables = Set<AnyCancellable>()
    
    init(
        locationService: LocationService,
        weatherService: WeatherService
    ) {
        self.locationService = locationService
        self.weatherService = weatherService
    }
    
    func requestCurrentForecast() {
        locationService.requestCurrentLocation { [weak self] location in
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
    
    func updateWeatherByCoordinates(location: LocationModel?) {
        guard let location else { return }
        
        status = .loading
        getWeatherByCoordinates(
            location: CLLocation(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            numberOfDays: 2
        )
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
                self?.currentLocation = response?.location
                self?.currentWeather = response?.currentWeather
                self?.hourlyForecast = response?.nextFewHoursForecast ?? []
                self?.status = .ready
            }
            .store(in: &cancellables)
    }
    
    func getWeatherByCity(
        city: String,
        numberOfDays: Int
    ) {
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
                self?.currentLocation = response?.location
                self?.currentWeather = response?.currentWeather
                self?.hourlyForecast = response?.nextFewHoursForecast ?? []
                self?.status = .ready
            }.store(in: &cancellables)
    }
}

extension WeatherViewModel {
    enum Status {
        case loading, ready, fail
    }
}
