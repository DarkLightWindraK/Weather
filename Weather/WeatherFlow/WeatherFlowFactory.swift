import Foundation
import SwiftUI

enum WeatherFlowFactory {
    static func makeWeatherDetailsScreen(
        currentLocation: LocationModel
    ) -> some View {
        let weatherDetailsViewModel = WeatherDetailsViewModel(location: currentLocation)
        let view = WeatherDetailsView(viewModel: weatherDetailsViewModel)
        return view
    }
}
