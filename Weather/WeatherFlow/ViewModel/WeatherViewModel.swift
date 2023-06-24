import Foundation
import Moya
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    @Published var currentCity: String?
    @Published var currentWeather: CurrentWeatherModel?
    @Published var hourlyForecast: [OneHourForecastModel] = []
    @Published var status: Status = .loading
    
    private let locationService: LocationService = LocationServiceImpl()
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    func requestCurrentForecast() {
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
            .getForecastByCoordinates(
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
                self?.currentWeather = response?.current
                self?.hourlyForecast = response?.hourlyForecast ?? []
                self?.status = .ready
            }
            .store(in: &cancellables)
    }
    
    func getWeatherByCity(
        city: String,
        numberOfDays: Int
    ) {
        weatherService
            .getForecastByCity(for: city)
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
                self?.currentWeather = response?.current
                self?.hourlyForecast = response?.hourlyForecast ?? []
                self?.status = .ready
            }.store(in: &cancellables)
    }
}

extension WeatherViewModel {
    enum Status {
        case loading, ready, fail
    }
}
