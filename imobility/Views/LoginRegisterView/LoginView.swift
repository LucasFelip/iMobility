import SwiftUI

struct Types: View {
    @State private var isShowingElements = false
    @State private var isShowingMap = false
    @State private var isShowingScreenRegister = false
    @State private var isShowingScreenLogin = false
    
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.02) {
            RegisterAppButton(action: {
                isShowingScreenRegister = true
            })
            .frame(width: UIScreen.main.bounds.width * 0.8)

            TypeLoginGoogleButton(action: {})
            .frame(width: UIScreen.main.bounds.width * 0.8)

            TypeLoginAppleButton(action: {})
            .frame(width: UIScreen.main.bounds.width * 0.8)

            TypeLoginAppButton(action: {
                isShowingScreenLogin = true
            })
            .frame(width: UIScreen.main.bounds.width * 0.8)

            TypeLoginBackButton(action: {
                isShowingMap = true
            })
            .frame(width: UIScreen.main.bounds.width * 0.8)
        }
        .opacity(isShowingElements ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeIn(duration: 2.0)) {
                isShowingElements = true
            }
        }
        .navigationDestination(isPresented: $isShowingScreenLogin, destination: {
            SingInView()
                .navigationBarBackButtonHidden(true)
        })
        .navigationDestination(isPresented: $isShowingMap, destination: {
            InitView()
                .navigationBarBackButtonHidden(true)
        })
        .navigationDestination(isPresented: $isShowingScreenRegister, destination: {
            RegisterView()
                .navigationBarBackButtonHidden(true)
        })
    }
}

struct LoginView: View {
    var body: some View {
        NavigationStack {
            VStack{
                Vector(imageName: "Vector 1", startXProportion: UIScreen.main.bounds.width, startYProportion: -UIScreen.main.bounds.height)
                TextImobility()
                    .padding(.top, UIScreen.main.bounds.height * 0.15)
                Types()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, UIScreen.main.bounds.height * 0.025)
                Vector(imageName: "Vector 2", startXProportion: -UIScreen.main.bounds.width, startYProportion: UIScreen.main.bounds.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
