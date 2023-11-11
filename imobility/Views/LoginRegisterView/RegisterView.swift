import SwiftUI

struct NameRegister: View {
    @Binding var name: String
    
    init(name: Binding<String>) {
        self._name = name
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Qual o seu nome?")
              .font(
                Font.custom("Montserrat", size: 20)
                  .weight(.medium)
              )
            TextField(" Digite seu nome", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 329)
                .font(Font.custom("Montserrat", size: 18))
                .padding(.vertical)
            Text("O nome que aparecera em seu perfil")
              .font(Font.custom("Montserrat", size: 12))
        }
    }
}

struct PasswordRegister: View {
    @Binding var password: String
    
    init(password: Binding<String>) {
        self._password = password
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Crie uma senha")
              .font(
                Font.custom("Montserrat", size: 20)
                  .weight(.medium)
              )
            SecureField(" Digite sua senha", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 329)
                .font(Font.custom("Montserrat", size: 18))
                .padding(.vertical)
            Text("Sua senha deve seguir os critérios de segurança")
              .font(Font.custom("Montserrat", size: 12))
        }
    }
}

struct EmailRegister: View {
    @Binding var email: String

    init(email: Binding<String>) {
        self._email = email
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Qual é o seu E-mail?")
              .font(
                Font.custom("Montserrat", size: 20)
                  .weight(.medium)
              )
            TextField(" Digite seu e-mail", text: $email)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 329)
                .font(Font.custom("Montserrat", size: 18))
                .padding(.vertical)
            Text("É necessario confirmar o e-mail depois")
              .font(Font.custom("Montserrat", size: 12))
        }
    }
}

struct StepsRegister: View {
    @EnvironmentObject private var userManager: UserManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    @State private var isNameValid = false
    @State private var isShowingElements = false
    @State private var currentStep: Int = 0
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    func nextStep() {
        if currentStep < 2 {
            currentStep += 1
        }
    }
    
    func handleResult(isValid: Bool, validationType: String) {
        if !isValid {
            showAlert = true
            switch validationType {
                case "Email":
                    alertTitle = "E-mail Inválido"
                    alertMessage = "Por favor, insira um e-mail válido."
                case "Password":
                    alertTitle = "Senha Inválido"
                    alertMessage = "Sua senha deve ter pelo menos 8 caracteres, incluindo pelo menos uma letra maiúscula, uma letra minúscula e pelo menos um caractere especial."
                case "Name":
                    alertTitle = "Nome Inválido"
                    alertMessage = "Seu nome deve ter pelo menos 3 caracteres, sem contar números."
                default:
                    alertTitle = "Erro inexperado"
                    alertMessage = "Entre em contato com a equipe de suporte."
            }
        }
    }
    
    func createAccount() {
        if isEmailValid && isPasswordValid && isNameValid {
            userManager.registerUser(name: name, email: email, password: password)
        } else {
            handleResult(isValid: false, validationType: "Form")
        }
    }

    var body: some View {
        VStack{
            switch currentStep {
            case 0:
                EmailRegister(email: $email)
                ButtonColorido(title: "Avançar") {
                    if isValidEmail(email) {
                        isEmailValid = true
                        nextStep()
                    } else {
                        handleResult(isValid: isEmailValid, validationType: "Email")
                    }
                }
            case 1:
                PasswordRegister(password: $password)
                ButtonColorido(title: "Avançar") {
                    if isValidPassword(password) {
                        isPasswordValid = true
                        nextStep()
                    } else {
                        handleResult(isValid: isPasswordValid, validationType: "Password")
                    }
                }
            case 2:
                NameRegister(name: $name)
                ButtonColorido(title: "Criar conta") {
                    if isValidName(name) {
                        isNameValid = true
                        createAccount()
                    } else {
                        handleResult(isValid: isNameValid, validationType: "Name")
                    }
                }
            default:
                EmptyView()
            }
        }
        .opacity(isShowingElements ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeIn(duration: 2.0)) {
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
        .navigationDestination(isPresented: $isNameValid, destination: {
            WelcomeView()
                .navigationBarBackButtonHidden(true)
        })
        
    }
}

struct RegisterView: View {
    @State private var isShowingButtonBack = true
    @State private var isCancelledregister = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Vector(imageName: "Vector 1", startX: UIScreen.main.bounds.width, startY: -UIScreen.main.bounds.height)
                StepsRegister().padding(.vertical, 150)
                Vector(imageName: "Vector 2", startX: -UIScreen.main.bounds.width, startY: UIScreen.main.bounds.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .edgesIgnoringSafeArea(.all)
            .navigationBarItems(leading: Group {
                if isShowingButtonBack {
                    Button(action: {
                        isCancelledregister = true
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                }
            })
            .navigationDestination(isPresented: $isCancelledregister, destination: {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            })
        }
    }
}
