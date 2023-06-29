import Foundation

struct CityModel: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}
