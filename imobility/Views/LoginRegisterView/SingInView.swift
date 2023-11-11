import SwiftUI

struct PasswordLogin: View {
    @Binding var password: String
    
    init(password: Binding<String>) {
        self._password = password
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Senha")
              .font(
                Font.custom("Montserrat", size: 20)
                  .weight(.medium)
              )
            SecureField(" Digite sua senha", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 329)
                .font(Font.custom("Montserrat", size: 18))
        }
    }
}

struct EmailLogin: View {
    @Binding var email: String

    init(email: Binding<String>) {
        self._email = email
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Email")
              .font(
                Font.custom("Montserrat", size: 20)
                  .weight(.medium)
              )
            TextField(" Digite seu e-mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .frame(width: 329)
                .font(Font.custom("Montserrat", size: 18))
        }
    }
}

struct StepsLogin: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        VStack(alignment: .trailing) {
            EmailLogin(email: $email)
                .padding(.bottom, 15)
            PasswordLogin(password: $password)
                .padding(.bottom, 15)
        }
        .padding(.vertical, 20)
    }
}

struct SingInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isShowingElements = false
    @State private var isShowingMap = false
    @State private var isCanceledLogin = false
    @State private var loginSucess = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @ObservedObject private var userManager = UserManager()
    
    func initAcess() {
        userManager.acessUser(email: email, password: password)
    }
    
    func handleResult(isValid: Bool, validationType: String) {
        if !isValid {
            showAlert = true
            switch validationType {
                case "User":
                    alertTitle = "Usuário Inválido"
                    alertMessage = "Por favor, faça login com um usuário válido."
                case "Email":
                    alertTitle = "Email Inválido"
                    alertMessage = "Por favor, faça login com um email válido."
                case "Password":
                    alertTitle = "Senha Inválida"
                    alertMessage = "Por favor, faça login com um senh@gmail. válido."
                default:
                    alertTitle = "Erro inexperado"
                    alertMessage = "Entre em contato com a equipe de suporte."
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Vector(imageName: "Vector 1", startX: UIScreen.main.bounds.width, startY: -UIScreen.main.bounds.height)
                TextImobility()
                StepsLogin(email: $email, password: $password)
                ButtonColorido(title: "Logar") {
                    if isValidEmail(email) {
                        if isValidPassword(password) {
                            isValidUser(email, password) { isValid in
                                if isValid {
                                    initAcess()
                                    loginSucess = true
                                } else {
                                    handleResult(isValid: false, validationType: "User")
                                }
                            }
                        } else {
                            handleResult(isValid: false, validationType: "Passoword")
                        }
                    } else {
                        handleResult(isValid: false, validationType: "Email")
                    }
                }
                TypeLoginBackButton(action: {
                    isCanceledLogin  = true
                })
                Vector(imageName: "Vector 2", startX: -UIScreen.main.bounds.width, startY: UIScreen.main.bounds.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .edgesIgnoringSafeArea(.all)
            .opacity(isShowingElements ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.easeIn(duration: 2.3)) {
                    isShowingElements = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $loginSucess, destination: {
                ContentView()
                    .navigationBarBackButtonHidden(true)
            })
            .navigationDestination(isPresented: $isCanceledLogin, destination: {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            })
        }
    }
}
