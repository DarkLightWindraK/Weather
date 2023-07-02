import Foundation

class LoginViewModel {
    private let sessionStore: SessionStore
    
    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }
    
    func updateSession(
        token: String,
        expirationTime: TimeInterval
    ) {
        sessionStore.updateSession(token: token, expirationTime: expirationTime)
    }
}
