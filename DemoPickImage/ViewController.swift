//
//  ViewController.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/5/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var selectedImage: UIImage? {
        didSet {
            uploadButton.isEnabled = true
            selectedImageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI() {
        uploadButton.isEnabled = false
    }
    
    private func uploadImageCompletion(model: BaseModel?) {
        var message = ""
        var title = ""
        var handler: ((UIAlertAction) -> Void)?
        if let result = model as? ResultModel {
            message = """
            id: \(result.id)
            link: \(result.link)
            """
            title = "Success"
            handler = { _ in
                UIApplication.shared.open(URL(string: result.link)!)
            }
        } else if let error = model as? ErrorModel {
            message = """
            error: \(error.error)
            status: \(error.status)
            """
            title = "Error"
        }
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func onUploadImage(_ sender: Any) {
        guard let image = selectedImageView.image else { return }
        indicator.startAnimating()
        view.isUserInteractionEnabled = false
        UploadService.shared.uploadImage(image: image) { model in
            self.indicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.uploadImageCompletion(model: model)
        }
    }
    
    @IBAction func unwindFromCamera(_ segue: UIStoryboardSegue) {
        if let vc = segue.source as? CameraVC {
            selectedImage = vc.selectedImage
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ImagePickerVC {
            vc.delegate = self
        }
    }
    
}

extension ViewController: ImagePickerDelegate {
    func done(with image: UIImage) {
        selectedImage = image
    }
}

