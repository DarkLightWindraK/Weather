import Foundation
import SwiftUI

class SessionStore: ObservableObject {
    @Published var token: String?
}
