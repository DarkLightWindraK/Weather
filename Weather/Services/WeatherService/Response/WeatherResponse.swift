import Foundation

struct Location: Decodable {
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    let timeZone: String
    let unixLocalTime: Double
    let localTime: String
    
    enum CodingKeys: String, CodingKey {
        case name, region, country
        case latitude = "lat"
        case longitude = "lon"
        case timeZone = "tz_id"
        case unixLocalTime = "localtime_epoch"
        case localTime = "localtime"
    }
}

struct WeatherCondition: Decodable {
    let description: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case description = "text"
        case code
    }
}

struct CurrentWeather: Decodable {
    let temperature: Double
    let condition: WeatherCondition
    let isDay: Int
    let wind: Double
    let pressure: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case condition, humidity
        case isDay = "is_day"
        case temperature = "temp_c"
        case wind = "wind_kph"
        case pressure = "pressure_mb"
    }
}

struct HourForecast: Decodable {
    let time: String
    let unixTime: Double
    let temperature: Double
    let condition: WeatherCondition
    let isDay: Int
    let wind: Double
    let pressure: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case time, condition, humidity
        case isDay = "is_day"
        case unixTime = "time_epoch"
        case temperature = "temp_c"
        case wind = "wind_kph"
        case pressure = "pressure_mb"
    }
}

struct DayForecast: Decodable {
    let unixDate: Double
    var hours: [HourForecast]
    
    enum CodingKeys: String, CodingKey {
        case hours = "hour"
        case unixDate = "date_epoch"
    }
}

struct WeatherForecast: Decodable {
    let days: [DayForecast]
    
    enum CodingKeys: String, CodingKey {
        case days = "forecastday"
    }
}

struct WeatherResponse: Decodable {
    let location: Location
    let current: CurrentWeather
    let forecast: WeatherForecast
}
