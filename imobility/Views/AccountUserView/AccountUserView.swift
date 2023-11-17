import SwiftUI

struct UserConfigs: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Configurações")
                .bold()
                .padding(.top, 5)
            
            Button(action: {
            }) {
                HStack {
                    Image(systemName: "shield.fill")
                    Text("Login & Segurança")
                }
            }
            .padding(.top, 10)

            Button(action: {
            }) {
                HStack {
                    Image(systemName: "gearshape.fill")
                    Text("Acessibilidade")
                }
            }
            .padding(.top, 10)

            Button(action: {
            }) {
                HStack {
                    Image(systemName: "bell.fill")
                    Text("Notificações")
                }
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 10)
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
                .padding(.top, 5)

            Button(action: {
                isShowingReportView = true
            }) {
                HStack {
                    Image(systemName: "doc.text.fill")
                    Text("Gerar Relatório")
                }
            }
            .padding(.top, 10)

            Button(action: {
                isDisconnect = true
            }) {
                HStack {
                    Image(systemName: "power")
                    Text("Desconectar")
                }
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 10)
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
                        .frame(width: 100, height: 100)
                    VStack(alignment: .leading) {
                        Text("\(user.name)")
                            .font(.title)
                        Text("\(formattedPoints(points: user.points)) pontos")
                            .font(.headline)
                    }
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.purple)
                
                UserConfigs()
                    .padding(.top, 10)
                UserActions(isShowingInitView: $isShowingInitView, isShowingReportView: $isShowingReportView, isDisconnect: $isDisconnect)
                    .padding(.top, 10)
            }
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
                Vector(imageName: "Vector 1", startX: UIScreen.main.bounds.width, startY: -UIScreen.main.bounds.height)
                AccountUser()
                    .padding(.vertical, 100)
                Vector(imageName: "Vector 2", startX: -UIScreen.main.bounds.width, startY: UIScreen.main.bounds.height)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
