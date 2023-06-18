import Foundation
import Moya
import Combine

class WeatherService {
    private let apiClient = MoyaProvider<WeatherAPI>()
    
    func getWeatherByCoordinates(
        latitude: Double,
        longitude: Double,
        numberOfDays: Int = 1
    ) -> AnyPublisher<WeatherResponse, Error> {
        apiClient
            .requestPublisher(.getWeatherByCoordinates(latitude: latitude, longitude: longitude, days: numberOfDays))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getWeatherByCity(
        for city: String,
        numberOfDays: Int = 1
    ) -> AnyPublisher<WeatherResponse, Error> {
        apiClient
            .requestPublisher(.getWeatherByCity(city: city, days: numberOfDays))
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
