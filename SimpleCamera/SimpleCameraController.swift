//
//  SimpleCameraController.swift
//  SimpleCamera
//
//  Created by Simon Ng on 16/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleCameraController: UIViewController {

    @IBOutlet var cameraButton:UIButton!
    let captureSession = AVCaptureSession()
    
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage: UIImage?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Present the session for taking photot in full resolution
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        //Get the font and back-facing camera for taking photos
        for device in devices {
            if device.position == AVCaptureDevicePosition.back {
                backFacingCamera = device
            } else if device.position == AVCaptureDevicePosition.front {
                frontFacingCamera = device
            }
        }
        currentDevice = backFacingCamera
        
        
        //Configure the session with the output for capturing still images
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
            
            //Configure  the session with the input and the output devices
            captureSession.addInput(captureDeviceInput)
            captureSession.addOutput(stillImageOutput)
        } catch {
            print(error)
        }
        
        //Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        //Bring the camera button to front
        view.bringSubview(toFront: cameraButton)
        captureSession.startRunning()
        
        //Toggle Camera recognizer
        toggleCameraGestureRecognizer.direction = .up
        toggleCameraGestureRecognizer.addTarget(self, action: #selector(toggleCamera))
        view.addSubview(toggleCameraGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action methods
    
    func toggleCamera() {
        captureSession.beginConfiguration()
        
        //Changed the device based on the current camera
        let newDevice = (currentDevice?.position == AVCaptureDevicePosition.back) ? frontFacingCamera : backFacingCamera
        
        //remove all inputs from session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        //Change to the new input
        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    
    @IBAction func capture(sender: UIButton) {
        let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo)
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
            
            if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer) {
                self.stillImage = UIImage(data: imageData)
                self.performSegue(withIdentifier: "showPhoto", sender: self)
            }
            
        })
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the new controller using
        //Pass the selected ogject to the new view controller
        if segue.identifier == "showPhoto" {
            let photoController = segue.destination as! PhotoViewController
            photoController.image = stillImage
        }
    }
    
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
    
    }

}
