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
        longitude: Double
    ) -> AnyPublisher<DetailForecastModel?, Never>
    
    func getRelevantForecast(forecast: [HourForecastModel]) -> [HourForecastModel]
}

class WeatherServiceImpl: WeatherService {
    private let apiClient = MoyaProvider<WeatherAPI>()
    
    func getShortForecastByCoordinates(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<ShortForecastModel?, Never> {
        apiClient
            .requestPublisher(.getWeatherByCoordinates(latitude: latitude, longitude: longitude, days: 2))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { WeatherMapper.responseToShortForecastModel(response: $0) }
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
        longitude: Double
    ) -> AnyPublisher<DetailForecastModel?, Never> {
        apiClient
            .requestPublisher(.getWeatherByCoordinates(latitude: latitude, longitude: longitude, days: 14))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { WeatherMapper.responseToForecastDetails(response: $0) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func getRelevantForecast(forecast: [HourForecastModel]) -> [HourForecastModel] {
        let nextHourDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let nextHour = Calendar.current.component(.hour, from: nextHourDate)
        
        guard nextHour < forecast.count else { return [] }
        
        return Array(forecast[nextHour...])
    }
}
