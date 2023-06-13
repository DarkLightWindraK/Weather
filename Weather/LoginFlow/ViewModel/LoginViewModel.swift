import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    private let sessionStore: SessionStore
    
    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }
    
    func updateSession(token: String) {
        sessionStore.token = token
    }
}
