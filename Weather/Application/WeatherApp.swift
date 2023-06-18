import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var sessionStore: SessionStore = .init()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if sessionStore.isUserLoggedIn {
                    FlowViewFactory.makeWeatherView()
                } else {
                    FlowViewFactory.makeLoginView(sessionStore: sessionStore)
                }
            }
        }
    }
}
