import SwiftUI

struct Vector: View {
    @State private var isSliding = false
    let imageName: String
    let startXProportion: CGFloat
    let startYProportion: CGFloat

    init(imageName: String, startXProportion: CGFloat, startYProportion: CGFloat) {
        self.imageName = imageName
        self.startXProportion = startXProportion
        self.startYProportion = startYProportion
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .offset(x: isSliding ? 0 : startXProportion, y: isSliding ? 0 : startYProportion)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2)) {
                    isSliding = true
                }
            }
    }
}
