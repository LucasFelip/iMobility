import SwiftUI

struct TextImobility: View {
    @State private var isShowingText = false

    var body: some View {
        Text("iMobility")
            .font(Font.custom("Montserrat-Regular", size: UIScreen.main.bounds.width * 0.15)) // Tamanho da fonte responsivo
            .opacity(isShowingText ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    isShowingText = true
                }
            }
    }
}

struct ContentView: View {
    @State private var isShowingInitView = false

    var body: some View {
        NavigationStack {
            VStack {
                Vector(imageName: "Vector 1", startXProportion: UIScreen.main.bounds.width * 0.8, startYProportion: -UIScreen.main.bounds.height * 0.8)
                TextImobility()
                    .padding(.vertical, UIScreen.main.bounds.height * 0.1)
                Vector(imageName: "Vector 2", startXProportion: -UIScreen.main.bounds.width * 0.8, startYProportion: UIScreen.main.bounds.height * 0.8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isShowingInitView = true
                }
            }
            .navigationDestination(isPresented: $isShowingInitView, destination: {
                InitView()
                    .navigationBarBackButtonHidden(true)
            })
        }
    }
}
