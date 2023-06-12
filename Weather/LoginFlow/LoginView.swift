import SwiftUI

struct LoginView: View {
    @State private var loginTextField: String = ""
    @State private var passwordTextField: String = ""
    
    var body: some View {
        VStack {
            Text("Авторизация")
                .font(.title2)
                .padding(.bottom)
            TextField("Ваш логин", text: $loginTextField)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .disabled(true)
            TextField("Ваш пароль", text: $passwordTextField)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .disabled(true)
            VStack {
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
                Button(
                    action: {},
                    label: {
                        Text("Войти через ВКонтакте")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.cornerRadius(10))
                            .foregroundColor(.white)
                    })
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
