import Foundation
import SwiftUI

class SessionStore: ObservableObject {
    @Published private(set) var isUserLoggedIn: Bool
    
    private(set) var token: String?
    private(set) var expirationDate: Date?
    
    private let storage = UserDefaults.standard
    
    init() {
        token = storage.string(forKey: Constants.tokenKey)
        expirationDate = storage.object(forKey: Constants.expirationDate) as? Date
        
        if
            self.token != nil,
            let expirationDate,
            expirationDate > .now
        {
            isUserLoggedIn = true
        } else {
            isUserLoggedIn = false
        }
    }
    
    func updateToken(
        token: String,
        expirationTime: TimeInterval
    ) {
        let tokenExpireDate = Date(timeIntervalSinceNow: expirationTime)
        
        self.token = token
        self.expirationDate = tokenExpireDate
        
        storage.set(token, forKey: Constants.tokenKey)
        storage.set(tokenExpireDate, forKey: Constants.expirationDate)
        
        isUserLoggedIn = tokenExpireDate > .now
    }
}

private extension SessionStore {
    enum Constants {
        static let tokenKey = "token_key"
        static let expirationDate = "expiration_date"
    }
}
