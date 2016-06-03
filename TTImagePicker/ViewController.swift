//
//  ViewController.swift
//  TTImagePicker
//
//  Created by wzh on 16/6/2.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy private  var imageView: UIImageView = {
        let object = UIImageView(image: UIImage(named: "FriendsBackground.png"))
//        let object = UIImageView()
        return object
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0));
        view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: -200))
        view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 80))
        view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 80))
        view.addOnClickListener(self, action: #selector(ViewController.imageViewClick(_:)))
    }
    func imageViewClick(imageView:UIImageView?) {
        TTImagePicker.showImagePickerFromViewController(self, allowsEditing: true, iconView: self.imageView) { (icon) in
            self.imageView.image = icon!
        }
//        TTImagePicker.showImagePickerFromViewController(self, allowsEditing: true) { (icon) in
//            self.imageView.image = icon
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UIView{
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        userInteractionEnabled = true
        addGestureRecognizer(gr)
    }
}

