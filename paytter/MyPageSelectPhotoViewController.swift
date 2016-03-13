//
//  MyPageSelectPhotoViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/13.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit
import AssetsLibrary

final class MyPageSelectPhotoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var assets = [ALAsset]()
    private var library = ALAssetsLibrary()
    private let kReuseIdentifier = "SelectPhotoCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePhotoLibrary()
        
        let userImage = UIImage.fontAwesomeIconWithName(.Times, textColor: UIColor.whiteColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(.AlwaysOriginal)
        let userButton = UIBarButtonItem(image: userImage, style: .Plain, target: self, action: "didTouchCloseButton:")
        
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = userButton
    }
    
    private func configurePhotoLibrary() {
        let authorizationStatus = ALAssetsLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .Authorized, .NotDetermined:
            library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: {
                (group: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if let group = group {
                    group.setAssetsFilter(ALAssetsFilter.allPhotos())
                    group.enumerateAssetsWithOptions(NSEnumerationOptions.Reverse, usingBlock: {
                        (result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                        if let result = result {
                            self.assets.append(result)
                        } else {
                            self.collectionView?.reloadData()
                        }
                    })
                }
                }, failureBlock: {
                    (error: NSError!) -> Void in
            })
        default:
            break
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = view.frame
        let space = 2.0
        let widthSize = (screenSize.size.width - CGFloat(space)) / 3
        let heightSize = widthSize
        let listCellSize = CGSizeMake(widthSize, heightSize)
        
        return listCellSize
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kReuseIdentifier, forIndexPath: indexPath) as! SelectPhotoCollectionViewCell
        
        if indexPath.item == 0 {
            cell.imageView.image = UIImage.fontAwesomeIconWithName(.Camera, textColor: UIColor.lightGrayColor(), size: CGSizeMake(130, 130)).imageWithRenderingMode(.AlwaysOriginal)
        } else {
            let asset = assets[indexPath.item - 1]
            cell.imageView.image = UIImage(CGImage: asset.thumbnail().takeUnretainedValue())
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            let imagePickerController = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                imagePickerController.sourceType = .Camera
                if UIImagePickerController.isCameraDeviceAvailable(.Front) {
                    imagePickerController.cameraDevice = .Front
                }
                
                // flashボタンをなくすためにカスタムViewを設定
                let cameraOverlayView = UIView(frame: CGRectMake(0.0, 0.0, 100.0, 40.0))
                let emptyBlackButton = UIButton(frame: CGRectMake(0.0, 0.0, 100.0, 40.0))
                emptyBlackButton.enabled = true
                cameraOverlayView.addSubview(emptyBlackButton)
                
                if UIDevice.currentDevice().model.hasPrefix("iPad") {
                    cameraOverlayView.backgroundColor = UIColor.clearColor()
                    emptyBlackButton.backgroundColor = UIColor.clearColor()
                } else {
                    cameraOverlayView.backgroundColor = UIColor.blackColor()
                    emptyBlackButton.backgroundColor = UIColor.blackColor()
                }
                
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.showsCameraControls = true
                imagePickerController.cameraOverlayView = cameraOverlayView
            }
            
            presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            let selectPhotoDetailViewController = ViewControllerFactory.selectPhotoDetailViewController()
            let assetRepresentation = assets[indexPath.item - 1].defaultRepresentation()
            
            selectPhotoDetailViewController.detailImage = UIImage(CGImage: assetRepresentation.fullScreenImage().takeUnretainedValue(), scale: CGFloat(assetRepresentation.scale()), orientation: .Up)
            navigationController?.pushViewController(selectPhotoDetailViewController, animated: true)
        }
    }
 
    dynamic private func didTouchCloseButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MyPageSelectPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: {
            let selectPhotoDetailViewController = ViewControllerFactory.selectPhotoDetailViewController()
            selectPhotoDetailViewController.detailImage = image
            self.navigationController?.pushViewController(selectPhotoDetailViewController, animated: true)
        })
    }
}