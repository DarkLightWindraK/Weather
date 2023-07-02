import SwiftUI

struct WeatherDetailsView: View {
    
    @ObservedObject var viewModel: WeatherDetailsViewModel
    
    private var hourFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru-RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru-RU")
        formatter.dateFormat = "EEE, d MMM, yyyy"
        return formatter
    }
    
    var body: some View {
        if viewModel.status == .loading {
            loadingView
                .onAppear {
                    viewModel.getDetailForecast()
                }
        } else if viewModel.status == .ready {
            weatherDetails
        }
    }
    
    var loadingView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(x: 2, y: 2, anchor: .center)
    }
    
    var weatherDetails: some View {
        List {
            Section("Сейчас") {
                WeatherForecastRow(
                    time: hourFormatter.string(from: Date()),
                    imageSystemName: viewModel.currentWeather?.weatherImage?.rawValue ?? "",
                    temperature: viewModel.currentWeather?.temperature ?? 0,
                    windSpeed: viewModel.currentWeather?.wind ?? 0,
                    pressure: viewModel.currentWeather?.pressure ?? 0)
            }
            .listSectionSeparator(.hidden)
            .frame(maxWidth: .infinity, alignment: .center)
            ForEach(viewModel.dailyForecast) { day in
                Section(dayFormatter.string(from: Date(timeIntervalSince1970: day.date))) {
                    ForEach(day.hourlyForecast) { hour in
                        WeatherForecastRow(
                            time: hourFormatter.string(from: Date(timeIntervalSince1970: hour.time)),
                            imageSystemName: hour.indicators.weatherImage?.rawValue ?? "",
                            temperature: hour.indicators.temperature,
                            windSpeed: hour.indicators.wind,
                            pressure: hour.indicators.pressure
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .listSectionSeparator(.hidden)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Подробный прогноз")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WeatherDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailsView(viewModel: WeatherDetailsViewModel(location: LocationModel(city: "VRN", latitude: 35, longitude: 35)))
    }
}
