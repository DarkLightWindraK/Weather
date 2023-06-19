import Foundation

struct OneHourForecastModel: Identifiable {
    let id = UUID()
    let time: String
    let temperature: Int
    let state: String
    let imageCode: Int
    let isDay: Int
    let wind: Int
    let pressure: Int
    let humidity: Int
}
