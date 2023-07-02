import Foundation
import Combine

class WeatherDetailsViewModel: ObservableObject {
    @Published var currentWeather: WeatherModel?
    @Published var dailyForecast: [DayForecastModel] = []
    @Published var status: Status = .loading
    
    private let currentLocation: LocationModel
    private let weatherService: WeatherService = Assembly.shared.resolve()
    private var cancellables = Set<AnyCancellable>()
    
    init(location: LocationModel) {
        self.currentLocation = location
    }
    
    func getDetailForecast() {
        weatherService
            .getForecastDetailsByCoordinates(
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude,
                days: 14
            )
            .sink { status in
                switch status {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                    self.status = .fail
                }
            } receiveValue: { [weak self] model in
                self?.currentWeather = model?.currentWeather
                self?.dailyForecast = model?.dailyForecast ?? []
                self?.status = .ready
            }
            .store(in: &cancellables)
    }
}

extension WeatherDetailsViewModel {
    enum Status {
        case loading, ready, fail
    }
}
