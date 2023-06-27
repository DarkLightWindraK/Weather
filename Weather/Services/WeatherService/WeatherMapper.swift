import Foundation

enum WeatherMapper {
    
    static func responseToShortForecastModel(response: WeatherResponse) -> ShortForecastModel {
        let location = LocationModel(city: response.location.name)
        let weatherModel = currentWeatherToModel(current: response.current)
        let fewHoursForecast = response.forecast.days.reduce(
            [HourForecastModel]()) { result, nextDay in
                let hours = nextDay.hours.map { hourForecastToModel(hourForecast: $0) }
                return result + hours
            }
        return ShortForecastModel(
            location: location,
            currentWeather: weatherModel,
            nextFewHoursForecast: fewHoursForecast
        )
    }
    
    static func responseToForecastDetails(response: WeatherResponse) -> DetailForecastModel {
        let currentWeather = currentWeatherToModel(current: response.current)
        let dailyForecast = response.forecast.days.map { dayForecastToModel(dayForecast: $0) }
        
        return DetailForecastModel(
            currentWeather: currentWeather,
            dailyForecast: dailyForecast
        )
    }
    
    static func currentWeatherToModel(current: CurrentWeather) -> WeatherModel {
        WeatherModel(
            temperature: Int(current.temperature),
            state: current.condition.description,
            weatherImage: WeatherImage(
                imageCode: current.condition.code,
                isDay: current.isDay
            ),
            wind: Int(current.wind / 3.6),
            pressure: Int(current.pressure * 0.75),
            humidity: current.humidity
        )
    }
    
    static func dayForecastToModel(dayForecast: DayForecast) -> DayForecastModel {
        DayForecastModel(
            date: dayForecast.unixDate,
            hourlyForecast: dayForecast.hours.map { hourForecastToModel(hourForecast: $0) }
        )
    }
    
    static func hourForecastToModel(hourForecast: HourForecast) -> HourForecastModel {
        HourForecastModel(
            time: hourForecast.unixTime,
            indicators: WeatherModel(
                temperature: Int(hourForecast.temperature),
                state: hourForecast.condition.description,
                weatherImage: WeatherImage(
                    imageCode: hourForecast.condition.code,
                    isDay: hourForecast.isDay
                ),
                wind: Int(hourForecast.wind / 3.6),
                pressure: Int(hourForecast.pressure * 0.75),
                humidity: hourForecast.humidity
            )
        )
    }
}
