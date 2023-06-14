import SwiftUI

@main
struct WeatherApp: App {
    @ObservedObject var sessionStore: SessionStore = .init()
    
    var body: some Scene {
        WindowGroup {
            if sessionStore.isUserLoggedIn {
                NavigationView {
                    FlowViewFactory.makeWeatherView()
                }
            } else {
                NavigationView {
                    FlowViewFactory.makeLoginView(sessionStore: sessionStore)
                }
            }
        }
    }
}
