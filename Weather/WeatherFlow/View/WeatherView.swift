import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            if viewModel.status == .loading {
                showLoadingView()
            } else if viewModel.status == .ready {
                makeTitleView()
                makeCurrentWeatherView()
                Spacer()
                makeNext5hoursInfoView()
                Spacer()
                makeHourlyForecastView()
            }
        }
        .onAppear {
            viewModel.requestWeather()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

private extension WeatherView {
    enum Constants {
        static let currentWeatherViewColor = Color(red: 97/255, green: 82/255, blue: 240/255)
    }
    
    func showLoadingView() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(x: 2, y: 2, anchor: .center)
    }
    
    func makeTitleView() -> some View {
        Text(viewModel.currentCity ?? "")
            .padding()
            .font(.title2)
            .bold()
    }
    
    func makeCurrentWeatherView() -> some View {
        VStack(spacing: 48) {
            Text("\(viewModel.currentWeather?.temperature ?? 0)°")
                .font(.system(size: 96))
                .bold()
            Text(viewModel.currentWeather?.state ?? "")
                .font(.system(size: 26))
                .bold()
                .padding(.bottom)
            HStack(spacing: 96) {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Влажность: \(viewModel.currentWeather?.humidity ?? 0)%")
                        .font(.system(size: 20))
                        .bold()
                    Text("Ветер: \(viewModel.currentWeather?.wind ?? 0) м/с")
                        .font(.system(size: 20))
                        .bold()
                    Text("Давление:\n\(viewModel.currentWeather?.pressure ?? 0) мм рт/ст")
                        .font(.system(size: 20))
                        .bold()
                }
                ImageStorage
                    .getImageByCode(
                        imageCode: viewModel.currentWeather?.imageCode ?? 1000,
                        isDay: viewModel.currentWeather?.isDay ?? 1
                    )
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
        .frame(width: 400, height: 425)
        .background(Constants.currentWeatherViewColor)
        .foregroundColor(.white)
        .cornerRadius(30)
    }
    
    func makeNext5hoursInfoView() -> some View {
        Text("Следующие 5 часов:")
            .bold()
            .font(.system(size: 20))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
    
    func makeHourlyForecastView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.hourlyForecast.prefix(5)) { item in
                    WeatherHourCell(
                        time: item.time,
                        temperature: item.temperature,
                        image: ImageStorage.getImageByCode(imageCode: item.imageCode, isDay: item.isDay)
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}
