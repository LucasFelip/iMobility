import SwiftUI

struct CategorySelectionView: View {
    @State private var allCategories: [TypeOccurrence] = TypeOccurrence.allCases
    @State private var isConfirmButtonVisible = false
    
    @Binding var selectedCategory: TypeOccurrence
    @Binding var isConfirmSelection: Bool
    @Binding var insertType: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0){
                ZStack {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 30)
                        .foregroundColor(Color.gray.opacity(0.5))
                    Text("Clique aqui para cancelar")
                        .font(.caption)
                        .foregroundColor(.white)
                        .bold()
                }
                .frame(height: 30)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.25, green: 0.55, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.7, green: 0.23, blue: 0.86), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.96, y: 1),
                        endPoint: UnitPoint(x: -0.05, y: -0.21)
                    )
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            isConfirmButtonVisible = false
                            isConfirmSelection = false
                            insertType = false
                        }
                )
                List {
                    ForEach(allCategories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            isConfirmButtonVisible = true
                        }) {
                            HStack {
                                Text(category.description)
                                Spacer()
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .accentColor(.primary)
                        }
                    }
                }
                if isConfirmButtonVisible {
                    ButtonRetangularSimple(buttonText: "Confirmar") {
                        isConfirmButtonVisible = false
                        isConfirmSelection = false
                        insertType = true
                    }
                }
            }
        }
    }
}
