import Foundation

struct WeatherModel {
    let location: LocationModel
    let current: CurrentWeatherModel
    let hourlyForecast: [OneHourForecastModel]
}

struct LocationModel {
    let city: String
}

struct CurrentWeatherModel {
    let temperature: Int
    let state: String
    let weatherImage: WeatherImage?
    let wind: Int
    let pressure: Int
    let humidity: Int
}

struct OneHourForecastModel: Identifiable {
    let id = UUID()
    let time: String
    let temperature: Int
    let state: String
    let weatherImage: WeatherImage?
    let wind: Int
    let pressure: Int
    let humidity: Int
}
