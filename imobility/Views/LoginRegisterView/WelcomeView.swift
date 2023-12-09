import SwiftUI

struct WelcomeView: View {
    @State private var isShowingElements = false
    @State private var isCreatedAccount = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Vector(imageName: "Vector 1", startXProportion: UIScreen.main.bounds.width, startYProportion: -UIScreen.main.bounds.height)
                VStack {
                    TextImobility()
                        .padding(.bottom)
                    Text("Conta criada com sucesso!")
                        .font(.system(size: UIScreen.main.bounds.width * 0.05))
                        .fontWeight(.medium)
                    ButtonColorido(title: "Iniciar") {
                        isCreatedAccount = true
                    }
                }
                .padding(.vertical, 150)
                Vector(imageName: "Vector 2", startXProportion: -UIScreen.main.bounds.width, startYProportion: UIScreen.main.bounds.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .edgesIgnoringSafeArea(.all)
            .opacity(isShowingElements ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.easeIn(duration: 2.0)) {
                    isShowingElements = true
                }
            }
            .navigationDestination(isPresented: $isCreatedAccount, destination: {
                SingInView()
                    .navigationBarBackButtonHidden(true)
            })
        }
    }
}
