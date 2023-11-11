import SwiftUI

struct TextImobility: View {
    @State private var isShowingText = false

    var body: some View {
        Text("iMobility")
            .font(Font.custom("Montserrat-Regular", size: 64))
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
                Vector(imageName: "Vector 1", startX: UIScreen.main.bounds.width, startY: -UIScreen.main.bounds.height)
                TextImobility()
                    .padding(.vertical, 200.0)
                Vector(imageName: "Vector 2", startX: -UIScreen.main.bounds.width, startY: UIScreen.main.bounds.height)
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
