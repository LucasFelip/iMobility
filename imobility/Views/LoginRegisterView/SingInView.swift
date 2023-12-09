import SwiftUI

struct PasswordLogin: View {
    @Binding var password: String
    
    init(password: Binding<String>) {
        self._password = password
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Senha")
                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                .fontWeight(.medium)
            
            SecureField(" Digite sua senha", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .font(.system(size: UIScreen.main.bounds.width * 0.045))
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
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
                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                .fontWeight(.medium)
            
            TextField(" Digite seu e-mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .font(.system(size: UIScreen.main.bounds.width * 0.045))
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
    }
}

struct StepsLogin: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        VStack(alignment: .trailing) {
            EmailLogin(email: $email)
                .padding(.bottom, UIScreen.main.bounds.height * 0.02)

            PasswordLogin(password: $password)
                .padding(.bottom, UIScreen.main.bounds.height * 0.02)
        }
        .padding(.vertical, UIScreen.main.bounds.height * 0.025)
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
    
    @EnvironmentObject private var userManager: UserManager
    
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
                Vector(imageName: "Vector 1", startXProportion: UIScreen.main.bounds.width, startYProportion: -UIScreen.main.bounds.height)
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
                Vector(imageName: "Vector 2", startXProportion: -UIScreen.main.bounds.width, startYProportion: UIScreen.main.bounds.height)
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
