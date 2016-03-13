//
//  MyPageViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton! {
        didSet {
            closeButton.setTitle(Icon.kClose, forState: .Normal)
        }
    }
    
    private var authorizeResponseJson: [String : AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.topViewController?.title = "マイページ"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserInterface", name: UIApplicationDidBecomeActiveNotification, object: nil)
        updateUserInterface()
        
        APIManager.sharedManager.postUserImage(profileImageView.image!)
    }

    @IBAction func authenticate(sender: UIButton) {
        APIManager.sharedManager.startOAuth2Login()
    }

    func updateUserInterface() {
        let userDefaults = NSUserDefaults.standardUserDefaults()

        profileImageUpdate(nil)

        if let myAccountId = userDefaults.objectForKey("mufgAccessToken") as? String {
            authButton.hidden = true

            if let userId = userDefaults.objectForKey("userId") as? String {
                let user = User.find()
                userProfileView.hidden = false
                nameLabel.text = user.name
                emailLabel.text = user.email
                
            } else {
                APIManager.sharedManager.getUserProfile({ result in
                    if let response = result as? [String : AnyObject] {
                        // NOTE: OAuth認証で返ってきたレスポンスをそのまま保持しておきます(その後カメラを開く)
                        self.authorizeResponseJson = response
                        self.openImagePicker()
                    }
                })
                let user = User.find()
                userProfileView.hidden = false
                nameLabel.text = user.name
                emailLabel.text = user.email
            }
        }
    }

    func profileImageUpdate(picture: UIImage?) {
        profileImageView.setNeedsLayout()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2.0
        profileImageView.layer.masksToBounds = true

        if (picture != nil) {
            profileImageView.image = picture
        }
    }

    func openImagePicker() {
        let imagePickerController = UIImagePickerController();
        imagePickerController.delegate = self
        imagePickerController.sourceType = .Camera
        // UIImagePickerControllerSourceType.PhotoLibraryでアルバムへのアクセス
        presentViewController(imagePickerController, animated:true, completion:nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage

            // NOTE: "Use Photo"が選択されたら画像更新
            profileImageUpdate(image)
            // NOTE: これでusersへのPOSTができます(順番的に写真とった後がいいかなと思ってここに書きました)
            APIManager.sharedManager.postUser([ "user" : self.authorizeResponseJson ])
        }

        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction private func didTouchCloseButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func didTouchUserImage(sender: UIImageView) {
        presentViewController(ViewControllerFactory.myPageSelectPhotoNavigationController(), animated: true, completion: nil)
    }
}
