import Foundation
import SwiftUI

enum LoginViewFactory {
    static func makeVKAuthWebView(
        viewModel: LoginViewModel?
    ) -> some View {
        var webView = AuthWebView()
        webView.loginViewModel = viewModel
        return webView
    }
}
