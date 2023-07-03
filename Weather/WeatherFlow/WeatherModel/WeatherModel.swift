import Foundation

struct ShortForecastModel {
    let location: LocationModel
    let currentWeather: WeatherModel
    let nextFewHoursForecast: [HourForecastModel]
}

struct DetailForecastModel {
    let currentWeather: WeatherModel
    let dailyForecast: [DayForecastModel]
}

struct LocationModel: Equatable {
    let city: String
    let latitude: Double
    let longitude: Double
}

struct WeatherModel {
    let temperature: Int
    let state: String
    let weatherImage: WeatherImage?
    let wind: Int
    let pressure: Int
    let humidity: Int
}

struct HourForecastModel: Identifiable {
    let id = UUID()
    let time: TimeInterval
    let indicators: WeatherModel
}

struct DayForecastModel: Identifiable {
    let id = UUID()
    let date: TimeInterval
    let hourlyForecast: [HourForecastModel]
}
