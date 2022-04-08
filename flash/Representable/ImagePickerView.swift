//
//  ImagePickerView.swift
//  flash
//
//  Created by Songwut Maneefun on 10/2/2565 BE.
//

import UIKit
import AVFoundation
import SwiftUI

struct ImagePickerView : View {
    @Binding var image: UIImage?
    @Binding var mediaUrl: URL?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var mediaTypes = ["public.movie"]//public.image
    
    var body: some View {
        ImagePickerViewController(image: $image,
                                  mediaUrl: $mediaUrl,
                                  sourceType: sourceType,
                                  mediaTypes: mediaTypes)
    }
}

struct ImagePickerViewController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var mediaUrl: URL?
    var sourceType = UIImagePickerController.SourceType.photoLibrary
    var mediaTypes = ["public.movie"]

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerViewController>) {
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerViewController>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.allowsEditing = true
        picker.mediaTypes = self.mediaTypes
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        picker.delegate = context.coordinator
        return picker
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {

        var parent: ImagePickerViewController

        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imagePicked = info[.editedImage] as? UIImage {
                //let reImage = imagePicked.cropRatio(16 / 9)
                //self.parent.image = reImage
                self.parent.cropImage(image: imagePicked, to: 9 / 17 ) { reImage in
                    self.parent.image = reImage
                }
            } else if let mediaUrl = info[.mediaURL] as? URL {
                self.parent.mediaUrl = mediaUrl
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    private func cropImage(image: UIImage, to aspectRatio: CGFloat,completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global(qos: .background).async {
            
            let imageAspectRatio = image.size.height / image.size.width
            
            var newSize = image.size
            
            if imageAspectRatio > aspectRatio {
                newSize.height = image.size.width * aspectRatio
            } else if imageAspectRatio < aspectRatio {
                newSize.width = image.size.height / aspectRatio
            } else {
                completion (image)
            }
            
            let center = CGPoint(x: image.size.width/2, y: image.size.height/2)
            let origin = CGPoint(x: center.x - newSize.width/2, y: center.y - newSize.height/2)
            
            let cgCroppedImage = image.cgImage!.cropping(to: CGRect(origin: origin, size: CGSize(width: newSize.width, height: newSize.height)))!
            let croppedImage = UIImage(cgImage: cgCroppedImage, scale: image.scale, orientation: image.imageOrientation)
            
            completion(croppedImage)
        }
    
    }
}

public struct ImagePickerViewforTest: UIViewControllerRepresentable {

    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
    @Environment(\.presentationMode) private var presentationMode

    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void

        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.onImagePicked(image)
            }
            self.onDismiss()
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }

    }

}
