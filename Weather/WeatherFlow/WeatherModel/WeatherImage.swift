import SwiftUI

typealias SystemName = String

enum WeatherImage: SystemName {
    case clearSun = "sun.max.fill"
    case clearMoon = "moon.fill"
    case cloudSun = "cloud.sun.fill"
    case cloudMoon = "cloud.moon.fill"
    case cloudy = "cloud.fill"
    case rainy = "cloud.rain.fill"
    case snowy = "cloud.snow.fill"
    case thunderstorm = "cloud.bolt.fill"
    case foggy = "cloud.fog.fill"
    
    init?(imageCode: Int, isDay: Int) {
        switch (imageCode, isDay) {
        case (1000, 1):
            self = .clearSun
        case (1000, 0):
            self = .clearMoon
        case (1003, 1):
            self = .cloudSun
        case (1003, 0):
            self = .cloudMoon
        case (1006...1009, _):
            self = .cloudy
        case (1063, _), (1069, _),
            (1150...1153, _), (1180...1195, _),
            (1204...1207, _), (1240...1252, _):
            self = .rainy
        case (1066, _), (1072, _), (1237, _),
            (1114...1117, _), (1210...1225, _),
            (1255...1264, _):
            self = .snowy
        case (1087, _), (1073...1282, _):
            self = .thunderstorm
        case (1030, _), (1135, _), (1147, _),
            (1168...1171, _), (1198...1201, _):
            self = .foggy
        default:
            return nil
        }
        
    }
}
