import SwiftUI

struct Types: View {
    @State private var isShowingElements = false
    @State private var isShowingMap = false
    @State private var isShowingScreenRegister = false
    @State private var isShowingScreenLogin = false
    
    var body: some View {
        VStack {
            RegisterAppButton(action: {
                isShowingScreenRegister = true
            })
            TypeLoginGoogleButton(action: {})
            TypeLoginAppleButton(action: {})
            TypeLoginAppButton(action: {
                isShowingScreenLogin = true
            })
            TypeLoginBackButton(action: {
                isShowingMap = true
            })
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
                Vector(imageName: "Vector 1", startX: UIScreen.main.bounds.width, startY: -UIScreen.main.bounds.height)
                TextImobility()
                    .padding(.top, 150)
                Types()
                    .frame(alignment: .center)
                    .padding(.vertical, 25)
                Vector(imageName: "Vector 2", startX: -UIScreen.main.bounds.width, startY: UIScreen.main.bounds.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
