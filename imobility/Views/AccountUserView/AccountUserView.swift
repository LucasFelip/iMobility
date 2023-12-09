import SwiftUI


struct UserConfigs: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Configurações")
                .bold()
                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                .padding(.top, UIScreen.main.bounds.height * 0.01)

            Button(action: {
            }) {
                HStack {
                    Image(systemName: "shield.fill")
                        .imageScale(.large)
                    Text("Login & Segurança")
                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                }
            }
            .padding(.top, UIScreen.main.bounds.height * 0.01)

            Button(action: {
            }) {
                HStack {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                    Text("Acessibilidade")
                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                }
            }
            .padding(.top, UIScreen.main.bounds.height * 0.01)
            
            Button(action: {
            }) {
                HStack {
                    Image(systemName: "bell.fill")
                        .imageScale(.large)
                    Text("Notificações")
                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                }
            }
            .padding(.top, UIScreen.main.bounds.height * 0.01)

        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.02)
        .accentColor(.primary)
    }
}

struct UserActions: View {
    @EnvironmentObject private var userManager: UserManager
    
    @Binding var isShowingInitView: Bool
    @Binding var isShowingReportView: Bool
    @Binding var isDisconnect: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ações")
                .bold()
                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                .padding(.top, UIScreen.main.bounds.height * 0.01)

            Button(action: {
                isShowingReportView = true
            }) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .imageScale(.large)
                    Text("Gerar Relatório")
                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                }
            }
            .padding(.top, UIScreen.main.bounds.height * 0.01)

            Button(action: {
                isDisconnect = true
            }) {
                HStack {
                    Image(systemName: "power.circle.fill")
                        .imageScale(.large)
                    Text("Desconectar")
                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                }
            }
            .padding(.top, UIScreen.main.bounds.height * 0.01)
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.02)
        .accentColor(.primary)
    }
}

struct AccountUser: View {
    @EnvironmentObject private var userManager: UserManager
    
    @State private var isShowingButtonBack = true
    @State private var isShowingInitView = false
    @State private var isDisconnect = false
    @State private var isShowingReportView = false
    
    func formattedPoints(points: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: points)) ?? "0,00"
    }
    
    var body: some View {
        if let user = userManager.currentUser {
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: UIImage(data: user.imagePerfilData) ?? UIImage(imageLiteralResourceName: "icon_user"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                    
                    VStack(alignment: .leading) {
                        Text("\(user.name)")
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                        Text("\(formattedPoints(points: user.points)) pontos")
                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
                        }
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.purple)
                                
                    UserConfigs()
                        .padding(.top, UIScreen.main.bounds.height * 0.01)
                    UserActions(isShowingInitView: $isShowingInitView, isShowingReportView: $isShowingReportView, isDisconnect: $isDisconnect)
                        .padding(.top, UIScreen.main.bounds.height * 0.01)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
            .navigationBarItems(leading: Group {
                if isShowingButtonBack {
                    Button(action: {
                        isShowingInitView = true
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                }
            })
            .navigationDestination(isPresented: $isShowingInitView, destination: {
                InitView()
                    .navigationBarBackButtonHidden(true)
            })
            .navigationDestination(isPresented: $isShowingReportView, destination: {
                ReportView()
                    .navigationBarBackButtonHidden(true)
            })
            .navigationDestination(isPresented: $isDisconnect, destination: {
                ContentView()
                    .navigationBarBackButtonHidden(true)
                    .onAppear{
                        userManager.disconnectUser()
                    }
            })
            .padding(.horizontal, 15)
            .onAppear {
                userManager.loadCurrentUserIfNeeded()
            }
        }
    }
}

struct AccontUserView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Vector(imageName: "Vector 1", startXProportion: UIScreen.main.bounds.width, startYProportion: -UIScreen.main.bounds.height)
                AccountUser()
                    .padding(.vertical, UIScreen.main.bounds.height * 0.05)
                Vector(imageName: "Vector 2", startXProportion: -UIScreen.main.bounds.width, startYProportion: UIScreen.main.bounds.height)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
