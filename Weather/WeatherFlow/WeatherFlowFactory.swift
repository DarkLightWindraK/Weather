import Foundation
import SwiftUI

enum WeatherFlowFactory {
    static func makeWeatherDetailsScreen(
        currentCity: String
    ) -> some View {
        let weatherDetailsViewModel = WeatherDetailsViewModel(city: currentCity)
        let view = WeatherDetailsView(viewModel: weatherDetailsViewModel)
        return view
    }
}
