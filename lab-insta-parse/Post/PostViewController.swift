//
//  PostViewController.swift
//  lab-insta-parse
//
//  Forked from Charlie Hieger on 11/1/22.
//  Created by Leonardo Villalobos on 3/2/23.
//

import UIKit
import PhotosUI
import ParseSwift

class PostViewController: UIViewController {
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var pickedImage: UIImage?

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideSpinner()
    }

    // MARK: IBActions
    @IBAction func onPickedImageTapped(_ sender: UIBarButtonItem) {
        var config: PHPickerConfiguration = .init()
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func onShareTapped(_ sender: Any) {
        view.endEditing(true)
        
        guard let image = pickedImage,
            let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        let imageFile = ParseFile(name: "image.jpg", data: imageData)
        let post: Post = .init(
            caption: captionTextField.text,
            user: User.current,
            imageFile: imageFile
        )
        
        self.showSpinner()
        post.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("Post saved: \(post)")
                    self?.hideSpinner()
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func onViewTapped(_ sender: Any) {
        view.endEditing(true)
    }

    // MARK: Private helpers
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(
            title: "Oops...",
            message: "\(description ?? "Please try again...")",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showSpinner() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    private func hideSpinner() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}

// MARK: Conform PostViewController to PHPickerViewControllerDelegate
extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
            provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let image = object as? UIImage else {
                self?.showAlert()
                return
            }
            if let error = error {
                self?.showAlert(description: error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self?.previewImageView.image = image
                self?.pickedImage = image
            }
        }
    }
}
