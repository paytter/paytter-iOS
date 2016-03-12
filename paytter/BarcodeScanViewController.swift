//
//  BarcodeScanViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var scanView: UIView!

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        APIManager.sharedManager.getProduct {
            (product: Product) -> Void in
            let scanItemDetailViewController = ViewControllerFactory.scanItemDetailViewController()
            scanItemDetailViewController.product = product
            self.presentViewController(scanItemDetailViewController, animated: true, completion: nil)
        }

        prepareScan()
        captureSession.startRunning();
    }

    func failed() {
        let ac = UIAlertController(title: "スキャン不可", message: "この端末はカメラでのスキャンがサポートされていません!", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }

    private func prepareScan() {
        captureSession = AVCaptureSession()

        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        scanView.layer.addSublayer(previewLayer);
    }

    // MARK: AVCaptureMetadataOutputObjectsDelegateのメソッド

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }

        dismissViewControllerAnimated(true, completion: nil)

        let delay = 1 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.captureSession.startRunning()
        })
    }

    func foundCode(code: String) {
        print(code)
        // NOTE: ここにバーコードを読み取り成功時の処理を書きます
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}
