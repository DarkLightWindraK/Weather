import SwiftUI

struct WeatherHourCell: View {
    
    private let time: TimeInterval
    private let temperature: Int
    private let systemImageName: SystemName
    
    private var hourFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru-RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    init(
        time: TimeInterval,
        temperature: Int,
        systemImageName: SystemName
    ) {
        self.time = time
        self.temperature = temperature
        self.systemImageName = systemImageName
    }
    
    var body: some View {
        VStack(spacing: 36) {
            Text(hourFormatter.string(from: Date(timeIntervalSince1970: time)))
                .font(.system(size: 24))
            Image(systemName: systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text("\(temperature)°")
                .font(.system(size: 22))
        }
        .padding(36)
        .foregroundColor(.white)
        .background(Color(red: 56/255, green: 77/255, blue: 104/255))
        .cornerRadius(30)
    }
}

struct WeatherHourRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherHourCell(
            time: Date().timeIntervalSince1970,
            temperature: 27,
            systemImageName: "sun.max.fill"
        )
    }
}

private extension WeatherHourCell {
    enum Constants {
        static let cellViewColor = Color(red: 56/255, green: 77/255, blue: 104/255)
    }
}
