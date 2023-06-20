import Foundation
import Moya
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    @Published var currentCity: String?
    @Published var currentWeather: CurrentWeatherModel?
    @Published var hourlyForecast: [OneHourForecastModel] = []
    @Published var status: Status = .loading
    
    private let weatherService = WeatherService()
    private let locationService = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var location: CLLocation?
    
    override init() {
        super.init()
        locationService.desiredAccuracy = kCLLocationAccuracyBest
        locationService.delegate = self
        locationService.requestWhenInUseAuthorization()
    }
    
    func requestWeather() {
        locationService.requestLocation()
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            getWeatherByCoordinates(numberOfDays: 7)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Не удалось определить местоположение. Запрос для стандартного города")
        getWeatherByCity(city: "Moscow", numberOfDays: 7)
    }
}

private extension WeatherViewModel {
    func getWeatherByCoordinates(numberOfDays: Int) {
        guard let location else { return }
        
        weatherService
            .getWeatherByCoordinates(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                numberOfDays: numberOfDays
            )
            .sink { status in
                switch status {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.currentCity = response.location.name
                self?.currentWeather = WeatherMapper.mapToCurrentWeather(response: response.current)
                self?.hourlyForecast = self?.getRelevantHourlyForecast(response: response.forecast) ?? []
                self?.status = .ready
            }
            .store(in: &cancellables)
    }
    
    func getWeatherByCity(
        city: String,
        numberOfDays: Int
    ) {
        weatherService
            .getWeatherByCity(for: city)
            .sink { status in
                switch status {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.currentCity = response.location.name
                self?.currentWeather = WeatherMapper.mapToCurrentWeather(response: response.current)
                self?.hourlyForecast = self?.getRelevantHourlyForecast(response: response.forecast) ?? []
                self?.status = .ready
            }.store(in: &cancellables)
    }
    
    func getRelevantHourlyForecast(response: WeatherForecast) -> [OneHourForecastModel] {
        let hourlyForecastArray = WeatherMapper.mapToHourlyForecastArray(response: response)
        let nextHourDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let nextHour = Calendar.current.component(.hour, from: nextHourDate)
        
        guard nextHour < hourlyForecastArray.count else { return [] }
        
        return Array(hourlyForecastArray[nextHour...])
    }
}

extension WeatherViewModel {
    enum Status {
        case loading, ready, fail
    }
}
