import Foundation
import Moya
import Combine

class WeatherService {
    private let apiClient = MoyaProvider<WeatherAPI>()
    
    func getForecastByCoordinates(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<WeatherModel?, Error> {
        apiClient
            .requestPublisher(.getWeatherByCoordinates(latitude: latitude, longitude: longitude, days: 2))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map({ [weak self] response in
                let location = WeatherMapper.mapToLocationModel(response: response.location)
                let current = WeatherMapper.mapToCurrentWeather(response: response.current)
                let hourlyForecast = WeatherMapper.mapToHourlyForecastArray(response: response.forecast)
                return WeatherModel(
                    location: location,
                    current: current,
                    hourlyForecast: self?.getRelevantForecast(
                        hourlyForecast: hourlyForecast
                    ) ?? []
                )
            })
            .eraseToAnyPublisher()
    }
    
    func getForecastByCity(
        for city: String
    ) -> AnyPublisher<WeatherModel?, Error> {
        apiClient
            .requestPublisher(.getWeatherByCity(city: city, days: 2))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map({ [weak self] response in
                let location = WeatherMapper.mapToLocationModel(response: response.location)
                let current = WeatherMapper.mapToCurrentWeather(response: response.current)
                let hourlyForecast = WeatherMapper.mapToHourlyForecastArray(response: response.forecast)
                return WeatherModel(
                    location: location,
                    current: current,
                    hourlyForecast: self?.getRelevantForecast(
                        hourlyForecast: hourlyForecast
                    ) ?? []
                )
            })
            .eraseToAnyPublisher()
    }
}

private extension WeatherService {
    func getRelevantForecast(hourlyForecast: [OneHourForecastModel]) -> [OneHourForecastModel] {
        let nextHourDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let nextHour = Calendar.current.component(.hour, from: nextHourDate)
        guard nextHour < hourlyForecast.count else { return [] }
        
        return Array(hourlyForecast[nextHour...])
    }
}
