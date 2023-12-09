import SwiftUI

struct TextRank: View {
    var body: some View {
        VStack {
            Text("Comunidade")
                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)

            Text("Você está vendo a lista de membros com as melhores pontuações da comunidade das ultimas 24 horas.")
                .font(.system(size: UIScreen.main.bounds.width * 0.03))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}


struct TableTop: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Pos")
                    .font(.system(size: UIScreen.main.bounds.width * 0.035))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("Membro")
                    .font(.system(size: UIScreen.main.bounds.width * 0.035))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Pontos")
                    .font(.system(size: UIScreen.main.bounds.width * 0.035))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Rectangle()
                .frame(height: 1)
        }
        .padding([.top, .leading, .trailing], 10.0)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct RankView: View {
    @EnvironmentObject private var userManager: UserManager
    var users: [User] {
        userManager.topTotalUsers
    }
    
    var body: some View {
        VStack {
            TextRank()
                .padding(.top, UIScreen.main.bounds.height * 0.02)

            TableTop()
            
            if users.isEmpty {
                ProgressView("Carregando usuários...")
                    .padding([.top, .leading, .trailing], UIScreen.main.bounds.width * 0.025)
                    .frame(alignment: .center)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(users.indices, id: \.self) { index in
                            HStack {
                                Text("\(index + 1)")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .overlay(
                                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                                            .mask(Text("\(index + 1)").font(.system(size: UIScreen.main.bounds.width * 0.05)))
                                    )
                                Text(users[index].name)
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(format: "%.2f", users[index].points))
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding([.top, .leading, .trailing], UIScreen.main.bounds.width * 0.025)
                            .frame(alignment: .center)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            userManager.sortAndLimitUsers()
        }
    }
}
