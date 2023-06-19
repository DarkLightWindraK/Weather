import Foundation
import SwiftUI

enum ImageStorage {
    static func getImageByCode(imageCode: Int, isDay: Int) -> Image {
        switch (imageCode, isDay) {
        case (1000, 1):
            return Image(systemName: "sun.max.fill")
        case (1000, 0):
            return Image(systemName: "moon.fill")
        case (1003, 1):
            return Image(systemName: "cloud.sun.fill")
        case (1003, 0):
            return Image(systemName: "cloud.moon.fill")
        case (1006...1009, _):
            return Image(systemName: "cloud.fill")
        case (1063, _),
            (1069, _),
            (1150...1153, _),
            (1180...1195, _),
            (1204...1207, _),
            (1240...1252, _):
            return Image(systemName: "cloud.rain.fill")
        case (1066, _),
            (1072, _),
            (1114...1117, _),
            (1210...1225, _),
            (1237, _),
            (1255...1264, _):
            return Image(systemName: "cloud.snow.fill")
        case (1087, _),
            (1073...1282, _):
            return Image(systemName: "cloud.bolt.fill")
        case (1030, _),
            (1135, _),
            (1147, _),
            (1168...1171, _),
            (1198...1201, _):
            return Image(systemName: "cloud.fog.fill")
        default:
            return Image(systemName: "sun.max.fill")
        }
    }
}
