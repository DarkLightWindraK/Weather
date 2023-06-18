import Foundation

struct OneHourForecastModel: Identifiable {
    let id = UUID()
    let time: String
    let temperature: Int
    let state: String
    let wind: Int
    let pressure: Int
    let humidity: Int
}
