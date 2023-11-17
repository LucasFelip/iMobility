import SwiftUI

struct OccurrenceView: View {
    @EnvironmentObject private var occurrenceManager: OccurrenceManager
    @EnvironmentObject private var userManager: UserManager
    
    @State private var isShowingElements = true
    @State private var isShowingButtonBack = true
    @State private var isShowingButton = true
    @State private var isShowingInitView = false
    
    @State private var insertLocal = false
    @State private var insertType = false
    @State private var insertPicture = false
    
    @State private var isConfirmLocation = false
    @State private var isConfirmCategory = false
    @State private var isConfirmPhoto = false
    
    @State private var isLocationSelection = MapLocation(latitude: 0, longitude: 0)
    @State private var isCategorySelection: TypeOccurrence = .buracoVia
    @State private var isImageSelection: Data?
    
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Image("report init")
                    .resizable()
                    .frame(width: 220, height: 202)
                    .opacity(isShowingElements ? 1.0 : 0.0)
                    
                if isShowingButton {
                    ButtonRetangular(buttonText: "Localização", action: {
                        isConfirmLocation = true
                    }, isCheckmarkVisible: $insertLocal)
                    ButtonRetangular(buttonText: "Categoria", action: {
                        isConfirmCategory = true
                    }, isCheckmarkVisible: $insertType)
                    ButtonRetangular(buttonText: "Foto", action: {
                        isConfirmPhoto = true
                    }, isCheckmarkVisible: $insertPicture)
                }
                if insertLocal && insertType && insertPicture {
                    ButtonColorido(title: "Enviar", action: {
                        occurrenceManager.registerOccurrenceUser(currentUser: UserManager().currentUser!, mapLocation: isLocationSelection, type: isCategorySelection, image: isImageSelection!)
                        isShowingInitView = true
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarItems(leading: Group {
                if isShowingButtonBack {
                    Button(action: {
                        isShowingInitView = true
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                }
            })
            .sheet(isPresented: $isConfirmLocation) {
                LocationSelectionView(selectLocation: $isLocationSelection, isConfirmLocation: $isConfirmLocation, insertLocal: $insertLocal)
            }
            .sheet(isPresented: $isConfirmCategory) {
                CategorySelectionView(selectedCategory: $isCategorySelection, isConfirmSelection: $isConfirmCategory, insertType: $insertType)
            }
            .actionSheet(isPresented: $isConfirmPhoto) {
                ActionSheet(title: Text("Escolha a Fonte da Imagem"),
                            message: Text("Selecione de onde deseja obter a imagem."),
                            buttons: [
                                .cancel(Text("Cancelar"), action: {
                                    isConfirmPhoto = false
                                    insertPicture = false
                                }),
                                .default(Text("Usar Câmera"), action: {
                                    imageSourceType = .camera
                                    showImagePicker = true
                                }),
                                .default(Text("Selecionar da Galeria"), action: {
                                    showImagePicker = true
                                })
                            ])
            }
            .sheet(isPresented: $showImagePicker) {
                ImageSelectionView(sourceType: $imageSourceType, imageData: $isImageSelection, isConfirmPhoto: $isConfirmPhoto)
            }
            .navigationDestination(isPresented: $isShowingInitView, destination: {
                InitView()
                    .navigationBarBackButtonHidden(true)
            })
        }
    }
}
