import Foundation
import SwiftUI
import WebKit

struct AuthWebView: UIViewRepresentable {
    
    private let viewModel: LoginViewModel = Assembly.shared.resolve()
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = Constants.urlPath
        urlComponents.queryItems = Constants.urlQueryItems
        
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> AuthWebViewCoordinator {
        let coordinator = AuthWebViewCoordinator()
        
        coordinator.onTokenReceived = { (token, time) in
            self.viewModel.updateSession(token: token, expirationTime: time)
        }
        
        return coordinator
    }
}

class AuthWebViewCoordinator: NSObject, WKNavigationDelegate {
    
    var onTokenReceived: ((_ token: String, _ time: TimeInterval) -> Void)?
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard
            let url = navigationResponse.response.url,
            url.path == Constants.urlResponsePath,
            let fragment = url.fragment()
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, parameter in
                var dict = result
                let key = parameter[0]
                let value = parameter[1]
                dict[key] = value
                
                return dict
            }
        
        if
            let token = params[Constants.accessTokenQueryParameter],
            let expirationTime = TimeInterval(params[Constants.expireTimeToken] ?? "")
        {
            onTokenReceived?(token, expirationTime)
        }
        
        decisionHandler(.cancel)
    }
}

private extension AuthWebView {
    enum Constants {
        static let urlScheme = "https"
        static let urlHost = "oauth.vk.com"
        static let urlPath = "/authorize"
        static let urlQueryItems = [
            URLQueryItem(name: "client_id", value: "51672428"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token")
        ]
    }
}

private extension AuthWebViewCoordinator {
    enum Constants {
        static let urlResponsePath = "/blank.html"
        static let accessTokenQueryParameter = "access_token"
        static let expireTimeToken = "expires_in"
    }
}
