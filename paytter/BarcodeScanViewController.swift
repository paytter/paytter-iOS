//
//  BarcodeScanViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

class BarcodeScanViewController: UIViewController {

    private var captureSession: AVCaptureSession!
    private var captureConnection: AVCaptureConnection!
    private var stillImageOutput: AVCaptureStillImageOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet private weak var scanView: UIView!
    @IBOutlet private weak var scanButton: UIButton!
    @IBOutlet private weak var rssiLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var sampleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareScan()
        captureSession.startRunning();

        // NOTE: このコメントを外すとバーコード読み取りが動き出す
//        BeaconScanner.sharedManager.delegate = self

//        APIManager.sharedManager.getProduct(storeId: 1, eanId: nil, isbnId: nil, itemIds: "food_0000121261", completion: {
//            (product: Product) -> Void in
//            let scanItemDetailViewController = ViewControllerFactory.scanItemDetailViewController()
//            scanItemDetailViewController.product = product
//            self.presentViewController(scanItemDetailViewController, animated: true, completion: nil)
//        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.running == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.running == true {
            captureSession.stopRunning()
        }
    }

    private func prepareScan() {
        captureSession = AVCaptureSession()
        stillImageOutput = AVCaptureStillImageOutput()

        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            captureSession.addOutput(stillImageOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        scanView.layer.addSublayer(previewLayer)
        scanView.layer.addSublayer(rssiLabel.layer)
        scanView.layer.addSublayer(distanceLabel.layer)
        scanView.layer.addSublayer(scanButton.layer)
        scanView.layer.addSublayer(sampleImageView.layer)
    }

    private func foundCode(code: String) {
        print(code)
        // NOTE: ここにバーコードを読み取り成功時の処理を書きます
        
        APIManager.sharedManager.getProduct(storeId: 1, eanId: Int(code)!, isbnId: nil, itemIds: nil, completion: {
            (product: Product) -> Void in
            let scanItemDetailViewController = ViewControllerFactory.scanItemDetailViewController()
            scanItemDetailViewController.product = product
            self.presentViewController(scanItemDetailViewController, animated: true, completion: nil)
        })
    }
    
    private func failed() {
        let ac = UIAlertController(title: "スキャン不可", message: "この端末はカメラでのスキャンがサポートされていません!", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }


    @IBAction func scanImage(sender: UIButton) {
        if let connection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) as? AVCaptureConnection {
            // ビデオ出力から画像を非同期で取得
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (imageDataBuffer, error) -> Void in

                // 取得画像のDataBufferをJpegに変換
                let imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)

                // JpegからUIImageを作成.
                let image:UIImage = UIImage(data: imageData)!
                self.sampleImageView.image = image
            })
        }
    }

}

extension BarcodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
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
}

extension BarcodeScanViewController: BeaconScannerDelegate {
    func didRangeBeacon(rssi rssi: String, distance: String) {
        print(rssi, distance)
        rssiLabel.text = "RSSI: \(rssi)"
        distanceLabel.text = "distance: \(distance)"
        
        if distance == "Far" {
            let purchase = Purchase(storeId: 1)
            APIManager.sharedManager.postPurchase(purchase)
            APIManager.sharedManager.postVisit(1, status: APIManager.Status.Out)
        }
        if distance == "" || distance == "" {
            APIManager.sharedManager.postVisit(1, status: APIManager.Status.In)
        }
    }
}