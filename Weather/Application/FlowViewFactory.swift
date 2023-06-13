import Foundation
import SwiftUI

enum FlowViewFactory {
    static func makeLoginView(
        sessionStore: SessionStore
    ) -> some View {
        let viewModel = LoginViewModel(sessionStore: sessionStore)
        var view = LoginView()
        view.loginViewModel = viewModel
        return view
    }
    
    static func makeWeatherView() -> some View {
        WeatherView()
    }
}
