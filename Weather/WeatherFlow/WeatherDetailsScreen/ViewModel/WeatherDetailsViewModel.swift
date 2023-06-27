import Foundation
import Combine

class WeatherDetailsViewModel: ObservableObject {
    @Published var currentWeather: WeatherModel?
    @Published var dailyForecast: [DayForecastModel] = []
    @Published var status: Status = .loading
    
    private let city: String
    private let weatherService = ServicesAssembly.shared.resolve(WeatherService.self)
    private var cancellables = Set<AnyCancellable>()
    
    init(city: String) {
        self.city = city
    }
    
    func getDetailForecast() {
        guard let weatherService else { fatalError("Dependence \(String(describing: WeatherService.self)) not found") }
        
        weatherService
            .getForecastDetailsByCity(for: city)
            .sink { status in
                switch status {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
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
