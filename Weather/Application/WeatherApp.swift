import SwiftUI

@main
struct WeatherApp: App {
    @ObservedObject private var sessionStore: SessionStore = Assembly.shared.resolve()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if sessionStore.isUserLoggedIn {
                    WeatherView()
                } else {
                    LoginView()
                }
            }
        }
    }
}
