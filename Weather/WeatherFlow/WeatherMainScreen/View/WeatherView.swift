import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel: WeatherViewModel = Assembly.shared.resolve()
    
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
            .onChange(of: viewModel.currentLocation) { newValue in
                viewModel.updateWeatherByCoordinates(location: newValue)
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
        NavigationLink {
            CityPicker(currentLocation: $viewModel.currentLocation)
        } label: {
            HStack {
                Text(viewModel.currentLocation?.city ?? "")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.black.opacity(0.5))
            }
        }
    }
    
    func makeCurrentWeatherView() -> some View {
        VStack(spacing: 48) {
            Text(viewModel.currentWeather?.state ?? "")
                .frame(alignment: .center)
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
                ForEach(viewModel.hourlyForecast.prefix(5)) { item in
                    NavigationLink {
                        WeatherDetailsView()
                    } label: {
                        WeatherHourCell(
                            time: item.time,
                            temperature: item.indicators.temperature,
                            systemImageName: item.indicators.weatherImage?.rawValue ?? ""
                        )
                    }

                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}
