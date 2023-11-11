import SwiftUI

struct OccurrenceDetailView: View {
    @EnvironmentObject private var occurrenceManager: OccurrenceManager
    @EnvironmentObject private var userManager: UserManager
    
    @State var click = false
    
    @Binding var selectedOccurrence: Occurrence?
    @Binding var isShowingModal: Bool

    var body: some View {
        if let occurrence = selectedOccurrence {
            VStack {
                Vector(imageName: "Vector 1", startX: UIScreen.main.bounds.width, startY: -UIScreen.main.bounds.height)
                Text("Detalhes da ocorrência")
                    .font(.title)
                
                Image(uiImage: UIImage(data: occurrence.imageData) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                
                Text("Tipo: \(occurrence.type.rawValue)")
                    .font(.headline)
                
                HStack {
                    Button(action: {
                        if userManager.currentUser != nil && !click {
                            click = true
                            occurrence.positiveRateToggle()
                            DispatchQueue.global(qos: .background).async {
                                occurrenceManager.updateOccurrence(updateOccurrence: occurrence)
                            }
                        }
                    }) {
                        Label("Importante", systemImage: "hand.thumbsup")
                        Text("\(Int(occurrence.positiveRate))")
                    }
                    Button(action: {
                        if userManager.currentUser != nil && !click {
                            click = true
                            occurrence.negativeRateToggle()
                            DispatchQueue.global(qos: .background).async {
                                occurrenceManager.updateOccurrence(updateOccurrence: occurrence)
                            }
                        }
                    }) {
                        Label("Não Importante", systemImage: "hand.thumbsdown")
                        Text("\(Int(occurrence.negativeRate))")
                    }
                }
                .padding()

                ButtonRetangularSimple(buttonText: "Voltar", action: {
                    isShowingModal = false
                })
                Vector(imageName: "Vector 2", startX: -UIScreen.main.bounds.width, startY: UIScreen.main.bounds.height)
            }
            .edgesIgnoringSafeArea(.all)
            .accentColor(.purple)
            .alert(isPresented: $click) {
                Alert(
                    title: Text("Agradecemos sua interação!"),
                    message: Text("Sua interação com esta ocorrência está sendo registrada e é muito apreciada. Obrigado por sua contribuição!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
