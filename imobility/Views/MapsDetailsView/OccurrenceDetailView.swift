import SwiftUI

struct OccurrenceDetailView: View {
    @EnvironmentObject private var occurrenceManager: OccurrenceManager
    @EnvironmentObject private var userManager: UserManager
    
    @State private var hasInteracted = false
    @Binding var selectedOccurrence: Occurrence?
    @Binding var isShowingModal: Bool

    var body: some View {
        if let occurrence = selectedOccurrence {
            VStack {
                Vector(imageName: "Vector 1", startX: UIScreen.main.bounds.width, startY: -UIScreen.main.bounds.height)
                OccurrenceDetailsView(occurrence: occurrence)
                InteractionButtons(occurrence: occurrence, hasInteracted: $hasInteracted)
                ButtonRetangularSimple(buttonText: "Voltar", action: { isShowingModal = false })
                Vector(imageName: "Vector 2", startX: -UIScreen.main.bounds.width, startY: UIScreen.main.bounds.height)
            }
            .edgesIgnoringSafeArea(.all)
            .accentColor(.purple)
        }
    }
}

struct OccurrenceDetailsView: View {
    let occurrence: Occurrence

    var body: some View {
        VStack {
            Text("Detalhes da ocorrência").font(.title)
            Image(uiImage: UIImage(data: occurrence.imageData) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            Text("Tipo: \(occurrence.type.rawValue)").font(.headline)
        }
    }
}

struct InteractionButtons: View {
    let occurrence: Occurrence
    @Binding var hasInteracted: Bool
    @EnvironmentObject private var occurrenceManager: OccurrenceManager
    @EnvironmentObject private var userManager: UserManager

    var body: some View {
        HStack {
            RateButton(label: "Importante", imageName: "hand.thumbsup", rate: Int(occurrence.positiveRate)) {
                guard userManager.currentUser != nil && !hasInteracted else { return }
                hasInteracted = true
                occurrence.positiveRateToggle()
                updateOccurrence()
            }

            RateButton(label: "Não Importante", imageName: "hand.thumbsdown", rate: Int(occurrence.negativeRate)) {
                guard userManager.currentUser != nil && !hasInteracted else { return }
                hasInteracted = true
                occurrence.negativeRateToggle()
                updateOccurrence()
            }
        }
        .padding()
    }

    private func updateOccurrence() {
        DispatchQueue.global(qos: .background).async {
            occurrenceManager.updateOccurrence(updateOccurrence: occurrence)
        }
    }
}

struct RateButton: View {
    var label: String
    var imageName: String
    var rate: Int
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(label, systemImage: imageName)
            Text("\(Int(rate))")
        }
    }
}
