import Foundation

struct WeatherLocation: Decodable {
    let region: String
    let time: Int
    
    enum CodingKeys: String, CodingKey {
        case region
        case time = "localtime_epoch"
    }
}

struct WeatherCondition: Decodable {
    let description: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case description = "text"
        case imageURL = "icon"
    }
}

struct WeatherData: Decodable {
    let temperature: Double
    let condition: WeatherCondition
    let wind: Double
    let pressure: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case condition, humidity
        case temperature = "temp_c"
        case wind = "wind_kph"
        case pressure = "pressure_mb"
    }
}

struct WeatherResponse: Decodable {
    let location: WeatherLocation
    let current: WeatherData
}
