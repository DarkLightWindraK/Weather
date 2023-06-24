import Foundation

enum WeatherMapper {
    static func mapToLocationModel(response: Location) -> LocationModel {
        LocationModel(city: response.name)
    }
    
    static func mapToCurrentWeather(response: CurrentWeather) -> CurrentWeatherModel {
        CurrentWeatherModel(
            temperature: Int(response.temperature),
            state: response.condition.description,
            weatherImage: WeatherImage(imageCode: response.condition.code, isDay: response.isDay),
            wind: Int(response.wind * 1000 / 3600),
            pressure: Int(response.pressure * 0.75),
            humidity: response.humidity
        )
    }
    
    static func mapToHourlyForecastArray(response: WeatherForecast) -> [OneHourForecastModel] {
        var result: [OneHourForecastModel] = []
        response.days.forEach { dayForecast in
            dayForecast.hours.forEach { hourForecast in
                result.append(
                    OneHourForecastModel(
                        time: hourForecast.time.components(separatedBy: " ")[1],
                        temperature: Int(hourForecast.temperature),
                        state: hourForecast.condition.description,
                        weatherImage: WeatherImage(imageCode: hourForecast.condition.code, isDay: hourForecast.isDay),
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
