import Foundation
import Moya
import Combine

class WeatherService {
    private let apiClient = MoyaProvider<WeatherAPI>()
    
    func getCurrentWeather(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<CurrentWeather, Error> {
        apiClient.requestPublisher(.getCurrentWeather(latitude: latitude, longitude: longitude))
            .map({ $0.data })
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { WeatherMapper.map(response: $0) }
            .eraseToAnyPublisher()
    }
}
