import Foundation
import Moya
import Combine

protocol WeatherService {
    func getShortForecastByCoordinates(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<ShortForecastModel?, Never>
    
    func getShortForecastByCity(
        for city: String
    ) -> AnyPublisher<ShortForecastModel?, Never>
    
    func getForecastDetailsByCoordinates(
        latitude: Double,
        longitude: Double,
        days: Int
    ) -> AnyPublisher<DetailForecastModel?, Never>
    
    func getForecastDetailsByCity(
        for city: String,
        days: Int
    ) -> AnyPublisher<DetailForecastModel?, Never>
}

class WeatherServiceImpl: WeatherService {
    private let apiClient: MoyaProvider<WeatherAPI>
    
    init(apiClient: MoyaProvider<WeatherAPI>) {
        self.apiClient = apiClient
    }
    
    func getShortForecastByCoordinates(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<ShortForecastModel?, Never> {
        apiClient
            .requestPublisher(.getWeatherByCoordinates(latitude: latitude, longitude: longitude, days: 2))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { WeatherMapper.responseToShortForecastModel(response: $0) }
            .map({ model in
                let nextHourDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
                let nextHour = Calendar.current.component(.hour, from: nextHourDate)
                
                guard nextHour < model.nextFewHoursForecast.count else {
                    return ShortForecastModel(
                        location: model.location,
                        currentWeather: model.currentWeather,
                        nextFewHoursForecast: []
                    )
                }
                
                return ShortForecastModel(
                    location: model.location,
                    currentWeather: model.currentWeather,
                    nextFewHoursForecast: Array(model.nextFewHoursForecast[nextHour...])
                )
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func getShortForecastByCity(
        for city: String
    ) -> AnyPublisher<ShortForecastModel?, Never> {
        apiClient
            .requestPublisher(.getWeatherByCity(city: city, days: 2))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { WeatherMapper.responseToShortForecastModel(response: $0) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func getForecastDetailsByCoordinates(
        latitude: Double,
        longitude: Double,
        days: Int
    ) -> AnyPublisher<DetailForecastModel?, Never> {
        apiClient
            .requestPublisher(.getWeatherByCoordinates(latitude: latitude, longitude: longitude, days: days))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { WeatherMapper.responseToForecastDetails(response: $0) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func getForecastDetailsByCity(
        for city: String,
        days: Int
    ) -> AnyPublisher<DetailForecastModel?, Never> {
        apiClient
            .requestPublisher(.getWeatherByCity(city: city, days: days))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { WeatherMapper.responseToForecastDetails(response: $0) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
