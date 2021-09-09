//
//  FLPostViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 8/9/2564 BE.
//

import UIKit

final class FLPostViewController: UIViewController, NibBased, ViewModelBased {
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var imageButton: UIButton!
    @IBOutlet private weak var cancleButton: UIButton!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var myLibraryButton: UIButton!
    
    var viewModel: FLPostViewModel! {
        didSet {
            let detail = self.viewModel.detail
            detail.status = .waitForApprove
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.isHidden = false
        self.cancleButton.isHidden = true
        self.coverImageView.image = UIImage(named: "flash-cover")
        self.imageButton.backgroundColor = ColorHelper.elementBackground()
        self.loadDetail(self.viewModel.detail)
    }
    
    func loadDetail(_ detail: FLDetailResult) {
        if detail.status == .unpublish {
            self.submitButton.isHidden = false
            self.cancleButton.isHidden = true
        } else if detail.status == .waitForApprove  {
            self.submitButton.isHidden = true
            self.cancleButton.isHidden = false
        }
    }
    
    @IBAction func imagePressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.image"]
        picker.videoQuality = .typeHigh
        picker.isEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        let detail = self.viewModel.detail
        self.openPopupWith(status: detail.status)
    }
    
    @IBAction func canclePressed(_ sender: UIButton) {
        let detail = self.viewModel.detail
        self.openPopupWith(status: detail.status)
    }
    
    func openPopupWith(status: FLStatus) {
        let detail = self.viewModel.detail
        var desc = "Do you confirm to submit this material?"
        if status == .waitForApprove {
            desc = "Do you confirm to cancel the request?"
        }
        
        let confirm = ActionButton(
            title: "confirm".localized(),
            action: DidAction(handler: { [weak self] (sender) in
                self?.submitPost(detail)
            })
        )
        PopupManager.showWarning(desc, confirm: confirm, at: self)
    }
    
    func submitPost(_ detail: FLDetailResult?) {
        print("submit confirm")
    }
    
    @IBAction func myLibraryPressed(_ sender: UIButton) {
        //TODO: dismiss and back to my library
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FLPostViewController: TagListSelectViewControllerDelegate {
    func tagListSelectViewController(_ tags: [UGCTagResult]) {
        print("select: \(tags.count) tag")
    }
}


extension FLPostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let originalImage = info[.originalImage] as? UIImage {
            let size = originalImage.size
            var newWidth: CGFloat = 1024
            if size.height > size.width {// 3000, 2000
                let ratio = size.width / size.height
                newWidth = 1024 * ratio
            }
            let img = originalImage.resizeImage(newWidth: newWidth)
            let imgData = img.jpeg ?? img.png
            guard let data = imgData else { return }
            var imageSize: Int = data.count
            print("actual size of image in KB: %f ", Double(imageSize) / 1024.0)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
