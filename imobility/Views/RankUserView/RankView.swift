import SwiftUI

struct TextRank: View {
    var body: some View {
        VStack {
            Text("Comunidade")
              .font(
                Font.custom("Montserrat", size: 18)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .frame(width: 128, height: 27, alignment: .leading)
            Text("Você está vendo a lista de membros com as melhores pontuações da comunidade das ultimas 24 horas.")
              .font(
                Font.custom("Montserrat", size: 12)
                  .weight(.medium)
              )
              .foregroundColor(.gray)
              .frame(height: 33, alignment: .center)
        }
        .frame(alignment: .top)
    }
}

struct TableTop: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Pos")
                    .font(
                        Font.custom("Montserrat", size: 14)
                            .weight(.semibold)
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Membro")
                    .font(
                        Font.custom("Montserrat", size: 14)
                            .weight(.semibold)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Pontos")
                    .font(
                        Font.custom("Montserrat", size: 14)
                            .weight(.semibold)
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Rectangle()
                .frame(height: 1)
        }
        .padding([.top, .leading, .trailing], 10.0)
        .frame(alignment: .center)
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
            TableTop()
            if users.isEmpty {
                ProgressView("Carregando usuários...")
                    .padding([.top, .leading, .trailing], 10.0)
                    .frame(alignment: .center)
            } else{
                ScrollView {
                    LazyVStack {
                        ForEach(users.indices, id: \.self) { index in
                            HStack {
                                Text("\(index + 1)")
                                    .font(Font.custom("Montserrat", size: 20))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .overlay(
                                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                                            .mask(Text("\(index + 1)").font(Font.custom("Montserrat", size: 20)))
                                    )
                                Text(users[index].name)
                                    .font(Font.custom("Montserrat", size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(format: "%.2f", users[index].points))
                                    .font(Font.custom("Montserrat", size: 16))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding([.top, .leading, .trailing], 10.0)
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
