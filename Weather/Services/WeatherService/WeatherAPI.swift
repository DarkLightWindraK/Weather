import Foundation
import Moya

enum WeatherAPI {
    case getWeatherByCoordinates(
        latitude: Double,
        longitude: Double,
        days: Int
    )
    case getWeatherByCity(
        city: String,
        days: Int
    )
}

extension WeatherAPI: TargetType {
    var baseURL: URL { URL(string: "https://api.weatherapi.com/v1")! }
    
    var path: String {
        switch self {
        case .getWeatherByCoordinates, .getWeatherByCity:
            return "/forecast.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeatherByCoordinates, .getWeatherByCity:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getWeatherByCoordinates(latitude, longitude, days):
            return .requestParameters(
                parameters: [
                    "key": Constants.apiKey,
                    "q": "\(latitude),\(longitude)",
                    "days": days,
                    "lang": "ru"
                ],
                encoding: URLEncoding.queryString
            )
        case let .getWeatherByCity(city, days):
            return .requestParameters(
                parameters: [
                    "key": Constants.apiKey,
                    "q": "\(city)",
                    "days": days,
                    "lang": "ru"
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        nil
    }
}

private extension WeatherAPI {
    enum Constants {
        static let apiKey = "c175b7996c28407cacf201740231506"
    }
}
