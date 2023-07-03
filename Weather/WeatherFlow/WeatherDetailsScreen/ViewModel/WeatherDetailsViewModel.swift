import Foundation
import Combine

class WeatherDetailsViewModel: ObservableObject {
    @Published var currentWeather: WeatherModel?
    @Published var dailyForecast: [DayForecastModel] = []
    @Published var status: Status = .loading
    
    private let locationService: LocationService
    private let weatherService: WeatherService
    private var cancellables = Set<AnyCancellable>()
    
    init(
        locationService: LocationService,
        weatherService: WeatherService
    ) {
        self.locationService = locationService
        self.weatherService = weatherService
    }
    
    func getDetailForecast() {
        var operation: AnyPublisher<DetailForecastModel?, Never>
        
        if let currentLocation = locationService.getLastSavedLocation() {
            operation = weatherService.getForecastDetailsByCoordinates(
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude,
                days: 14
            )
        } else {
            operation = weatherService.getForecastDetailsByCity(
                for: Constants.defaultCuty,
                days: 14
            )
        }
        operation.sink { status in
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

private extension WeatherDetailsViewModel {
    enum Constants {
        static let defaultCuty = "Moscow"
    }
}

extension WeatherDetailsViewModel {
    enum Status {
        case loading, ready, fail
    }
}
