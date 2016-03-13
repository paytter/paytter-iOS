//
//  SelectPhotoDetailViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/13.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class SelectPhotoDetailViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    var detailImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = detailImage
    }
    
    @IBAction func didTouchUseButton(sender: UIButton) {
        APIManager.sharedManager.postUserImage(detailImage)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTouchCancelButton(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}
