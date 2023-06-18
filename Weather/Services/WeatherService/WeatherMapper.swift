import Foundation

enum WeatherMapper {
    static func mapToCurrentWeather(response: WeatherResponse) -> CurrentWeatherModel {
        CurrentWeatherModel(
            temperature: Int(response.current.temperature),
            state: response.current.condition.description,
            wind: Int(response.current.wind * 1000 / 3600),
            pressure: Int(response.current.pressure * 0.75),
            humidity: response.current.humidity
        )
    }
    
    static func mapToHourlyForecastArray(response: WeatherResponse) -> [OneHourForecastModel] {
        var result: [OneHourForecastModel] = []
        response.forecast.days.forEach { dayForecast in
            dayForecast.hours.forEach { hourForecast in
                result.append(
                    OneHourForecastModel(
                        time: hourForecast.time.components(separatedBy: " ")[1],
                        temperature: Int(hourForecast.temperature),
                        state: hourForecast.condition.description,
                        wind: Int(hourForecast.wind * 1000 / 3600),
                        pressure: Int(hourForecast.pressure * 0.75),
                        humidity: hourForecast.humidity
                    )
                )
            }
        }
        return result
    }
}
