//
//  CameraVC.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/6/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var imagePreviewView: ImagePreview!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    var output: AVCaptureVideoDataOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var device: AVCaptureDevice?
    var deviceInput: AVCaptureDeviceInput?
    var usingFrontCamera = false
    var videoDataOutputQueue: DispatchQueue?
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreviewView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer?.frame = cameraView.bounds
        checkPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let captureSession = captureSession {
            captureSession.stopRunning()
        }
        cameraImageView.image = nil
    }

    func checkPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.loadCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.sync { [unowned self] in
                        self.loadCamera()
                    }
                } else {
                    Utils.showErrorAlert(message: "Bạn chưa cấp quyền truy cập camera", from: self)
                }
            })
        }
    }
    
    @objc func loadCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        device = (usingFrontCamera ? getFrontCamera() : getBackCamera())
        do {
            guard let device = device else { return }
            deviceInput = try AVCaptureDeviceInput(device: device)
            guard let deviceInput = deviceInput else {
                print("error: cant get deviceInput")
                return
            }
            
            if captureSession.canAddInput(deviceInput){
                captureSession.addInput(deviceInput)
            }
            
            if captureSession.canAddOutput(stillImageOutput){
                captureSession.addOutput(stillImageOutput)
            }
            
            stillImageOutput.connection(with: .video)?.isEnabled = true
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            guard let videoPreviewLayer = videoPreviewLayer else { return }
            videoPreviewLayer.videoGravity = .resizeAspectFill
            
            let rootLayer :CALayer = self.cameraImageView.layer
            rootLayer.masksToBounds = true
            videoPreviewLayer.frame = rootLayer.bounds
            rootLayer.addSublayer(videoPreviewLayer)
            captureSession.startRunning()
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }
    
    func getBackCamera() -> AVCaptureDevice? {
        return AVCaptureDevice.default(for: .video)
    }
    
    func getFrontCamera() -> AVCaptureDevice? {
        let videoDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices
        for element in videoDevices where element.position == AVCaptureDevice.Position.front {
            return element
        }
        return nil
    }
    
    @IBAction func switchToFrontCamera(_ sender: Any) {
        usingFrontCamera = !usingFrontCamera
        loadCamera()
    }
    
    @IBAction func closeCamera(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        stillImageOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        if let image = UIImage(data: imageData ?? Data()) {
            imagePreviewView.setImage(image: image)
            imagePreviewView.isHidden = false
        }
    }
}

extension CameraVC: ImagePreviewDelegate {
    func done(image: UIImage) {
        selectedImage = image
        performSegue(withIdentifier: "unwindFromCamera", sender: nil)
    }
}
