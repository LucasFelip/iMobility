import SwiftUI

struct Vector: View {
    @State private var isSliding = false
    let imageName: String
    let startX: CGFloat
    let startY: CGFloat

    init(imageName: String, startX: CGFloat, startY: CGFloat) {
        self.imageName = imageName
        self.startX = startX
        self.startY = startY
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .offset(x: isSliding ? 0 : startX, y: isSliding ? 0 : startY)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2)) {
                    isSliding = true
                }
            }
    }
}
