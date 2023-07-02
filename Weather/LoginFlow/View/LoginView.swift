import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @State private var loginTextField: String = ""
    @State private var passwordTextField: String = ""
    
    var body: some View {
        VStack {
            makeTitleLabel()
            makeLoginField()
            makePasswordField()
            VStack {
                makeLoginButton()
                makeVKLoginButton()
            }
            .padding(.top)
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

private extension LoginView {
    func makeTitleLabel() -> some View {
        Text("Авторизация")
            .font(.title2)
            .padding(.bottom)
    }
    
    func makeLoginField() -> some View {
        TextField("Ваш логин", text: $loginTextField)
            .padding()
            .background(Color.gray.opacity(0.3).cornerRadius(10))
            .disabled(true)
    }
    
    func makePasswordField() -> some View {
        TextField("Ваш пароль", text: $passwordTextField)
            .padding()
            .background(Color.gray.opacity(0.3).cornerRadius(10))
            .disabled(true)
    }
    
    func makeLoginButton() -> some View {
        Button(
            action: {},
            label: {
                Text("Войти")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.cornerRadius(10))
                    .foregroundColor(.white)
                    .disabled(true)
            })
    }
    
    func makeVKLoginButton() -> some View {
        NavigationLink {
            AuthWebView()
                .navigationBarBackButtonHidden(true)
        } label: {
            Text("Войти через ВКонтакте")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.cornerRadius(10))
                .foregroundColor(.white)
        }
    }
}
