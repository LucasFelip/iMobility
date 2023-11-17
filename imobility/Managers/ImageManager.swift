import SwiftUI

struct ImageManager: UIViewControllerRepresentable {
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: Data?

    init(sourceType: Binding<UIImagePickerController.SourceType>, selectedImage: Binding<Data?>) {
        _sourceType = sourceType
        _selectedImage = selectedImage
        
        if sourceType.wrappedValue == .camera && !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self._sourceType = .constant(.photoLibrary)
        }
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        if uiViewController.sourceType != sourceType && UIImagePickerController.isSourceTypeAvailable(sourceType) {
            uiViewController.sourceType = sourceType
        }
    }

    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(self)
    }
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImageManager

    init(_ parent: ImageManager) {
        self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            parent.selectedImage = image.pngData()
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension UIImage {
    func resizedToUnder1MB() -> UIImage? {
        guard let imageData = self.jpegData(compressionQuality: 1.0) else { return nil }
        let oneMegabyte = 1048576.0

        var resizingImage = self
        var imageSizeBytes = Double(imageData.count)

        while imageSizeBytes > oneMegabyte {
            guard let resizedImage = resizingImage.resized(withPercentage: 0.5),
                  let imageData = resizedImage.jpegData(compressionQuality: 1.0) else { return nil }
            
            resizingImage = resizedImage
            imageSizeBytes = Double(imageData.count)
        }
        
        return resizingImage
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
