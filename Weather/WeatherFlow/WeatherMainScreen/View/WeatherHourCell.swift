import SwiftUI

struct WeatherHourCell: View {
    
    private let time: String
    private let temperature: Int
    private let image: Image
    
    init(
        time: String,
        temperature: Int,
        image: Image
    ) {
        self.time = time
        self.temperature = temperature
        self.image = image
    }
    
    var body: some View {
        VStack(spacing: 48) {
            Text(time)
                .font(.system(size: 24))
            image
                .resizable()
                .frame(width: 50, height: 50)
            Text("\(temperature)°")
                .font(.system(size: 22))
        }
        .frame(width: 150, height: 250)
        .background(Constants.cellViewColor)
        .foregroundColor(Color.white)
        .cornerRadius(30)
    }
}

struct WeatherHourRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherHourCell(
            time: "14:00",
            temperature: 27,
            image: Image(systemName: "sun.max.fill")
        )
    }
}

private extension WeatherHourCell {
    enum Constants {
        static let cellViewColor = Color(red: 56/255, green: 77/255, blue: 104/255)
    }
}
