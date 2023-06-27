import SwiftUI

struct WeatherForecastRow: View {
    private let time: String
    private let imageSystemName: String
    private let temperature: Int
    private let windSpeed: Int
    private let pressure: Int
    
    init(
        time: String,
        imageSystemName: String,
        temperature: Int,
        windSpeed: Int,
        pressure: Int
    ) {
        self.time = time
        self.imageSystemName = imageSystemName
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.pressure = pressure
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text(time)
                .font(.system(size: 20))
            Spacer()
            VStack(spacing: 16) {
                Image(systemName: imageSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                Text("\(temperature)°")
                    .font(.system(size: 18))
            }
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                Text("\(windSpeed) м/c")
                    .font(.system(size: 18))
                Text("\(pressure) мм рт/ст")
                    .font(.system(size: 18))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(30)
    }
}

struct WeatherForecastRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastRow(
            time: "16:53",
            imageSystemName: "cloud.sun.fill",
            temperature: 32,
            windSpeed: 11,
            pressure: 761
        )
    }
}
