import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        if viewModel.status == .loading {
            showLoadingView()
                .onAppear {
                    viewModel.requestCurrentForecast()
                }
        } else if viewModel.status == .ready {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        makeCityView()
                        makeCurrentWeatherView()
                    }
                    .padding(.horizontal)
                    makeNext5hoursInfoView()
                    makeHourlyForecastView()
                }
            }
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
    
    func makeCityView() -> some View {
        Text(viewModel.currentCity ?? "")
            .font(.title3)
            .bold()
    }
    
    func makeCurrentWeatherView() -> some View {
        VStack(spacing: 48) {
            Text(viewModel.currentWeather?.state ?? "")
                .font(.system(size: 22))
                .bold()
            Text("\(viewModel.currentWeather?.temperature ?? 0)°")
                .font(.system(size: 84))
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Влажность: \(viewModel.currentWeather?.humidity ?? 0)%")
                        .font(.system(size: 20))
                    Text("Ветер: \(viewModel.currentWeather?.wind ?? 0) м/с")
                        .font(.system(size: 20))
                    Text("Давление: \n\(viewModel.currentWeather?.pressure ?? 0) мм рт/ст")
                        .font(.system(size: 20))
                }
                Spacer()
                Image(systemName: viewModel.currentWeather?.weatherImage?.rawValue ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(.indigo)
        .cornerRadius(30)
    }
    
    func makeNext5hoursInfoView() -> some View {
        Text(("Следующие 5 часов"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .font(.system(size: 20))
            .bold()
    }
    
    func makeHourlyForecastView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.hourlyForecast) { item in
                    VStack(spacing: 36) {
                        Text(item.time)
                            .font(.system(size: 24))
                        Image(systemName: item.weatherImage?.rawValue ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text("\(item.temperature)°")
                            .font(.system(size: 22))
                    }
                    .padding(36)
                    .foregroundColor(.white)
                    .background(Color(red: 56/255, green: 77/255, blue: 104/255))
                    .cornerRadius(30)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}
