import Foundation
import Moya

enum WeatherAPI {
    case getCurrentWeather(
        latitude: Double,
        longitude: Double
    )
}

extension WeatherAPI: TargetType {
    var baseURL: URL { URL(string: "https://api.weatherapi.com/v1")! }
    
    var path: String {
        switch self {
        case .getCurrentWeather:
            return "/current.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCurrentWeather:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getCurrentWeather(latitude, longitude):
            return .requestParameters(
                parameters: [
                    "key": Constants.apiKey,
                    "q": "\(latitude),\(longitude)"
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
