import SwiftUI

struct ImageSelectionView: View {
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var imageData: Data?
    @Binding var isConfirmPhoto: Bool
    
    var body: some View {
        VStack {
            content
        }
        .onChange(of: imageData) { _ in
            isConfirmPhoto = false
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            imageView(for: uiImage)
        } else {
            imagePickerManager
        }
    }
    
    private func imageView(for uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var imagePickerManager: some View {
        ImageManager(sourceType: $sourceType, selectedImage: $imageData)
    }
}
