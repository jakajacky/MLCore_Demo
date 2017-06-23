//
//  ViewController.swift
//  ML-ResNet
//
//  Created by XiaoQiang on 2017/6/7.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    let model = Resnet50()
    var captureSession:AVCaptureSession!
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        captureSession = AVCaptureSession()
      
        captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480
      
        let device = AVCaptureDevice.default(for: AVMediaType.video)
      
        guard let deviceInput = try? AVCaptureDeviceInput(device: device!) else {
            fatalError("error ssss")
        }
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
      
        let cameraOutput = AVCapturePhotoOutput()
      
        if (captureSession.canAddOutput(cameraOutput)) {
            captureSession.addOutput(cameraOutput)
        }
      
      
        let videoDataOutput = AVCaptureVideoDataOutput()
      
        let rgbOutputSettings = NSDictionary(object: NSNumber(value: kCMPixelFormat_32BGRA), forKey: kCVPixelBufferPixelFormatTypeKey as! NSCopying)
      
        videoDataOutput.videoSettings = rgbOutputSettings as! [String : Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
      
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
      
        if captureSession.canAddOutput(videoDataOutput) {
          captureSession.addOutput(videoDataOutput)
        }
        videoDataOutput.connection(with: AVMediaType.video)?.isEnabled = true
      
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
      
        // 识别图片
      /*
        let image:UIImage = UIImage(named: "f.png")!
        let pxbuffer = image.pixelBuffer(width: 224, height: 224)
        guard let output:Resnet50Output = try? model.prediction(image: pxbuffer!) else {
            fatalError("Unexpected runtime error.")
        }
        print("识别物体：\(output.classLabel)")
       */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }

}

