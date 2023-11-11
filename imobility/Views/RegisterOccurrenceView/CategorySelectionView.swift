import SwiftUI

struct CategorySelectionView: View {
    @State private var allCategories: [TypeOccurrence] = TypeOccurrence.allCases
    @State private var isConfirmButtonVisible = false
    
    @Binding var selectedCategory: TypeOccurrence
    @Binding var isConfirmSelection: Bool
    
    var body: some View {
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
                    .accentColor(.purple)
                }
            }
        }
        if isConfirmButtonVisible {
            ButtonRetangularSimple(buttonText: "Confirmar") {
                isConfirmButtonVisible = false
                isConfirmSelection = false
            }
        }
    }
}
