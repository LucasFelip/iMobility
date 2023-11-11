import SwiftUI

struct ImageSelectionView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var imageData: Data?
    @Binding var isConfirmPhoto: Bool
    
    var body: some View {
        VStack {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ImageManager(sourceType: $sourceType, selectedImage: $imageData)
            }
        }
        .onChange(of: imageData) { newValue in
            if newValue != nil {
                isConfirmPhoto = false
            }
        }
    }
}
