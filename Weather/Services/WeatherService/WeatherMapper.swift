import Foundation

enum WeatherMapper {
    static func map(response: WeatherResponse) -> CurrentWeather {
        CurrentWeather(
            city: response.location.region,
            temperature: response.current.temperature,
            state: response.current.condition.description,
            wind: response.current.wind,
            pressure: Int(response.current.pressure * 0.75),
            humidity: response.current.humidity
        )
    }
}
