//
//  TTImagePicker.swift
//  TTImagePicker
//
//  Created by wzh on 16/6/2.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit

class TTImagePicker: NSObject {
    ///  回调闭包
    ///
    ///  - returns: 回调闭包
    private var finishAction:((UIImage?)->Void)?
    private static var imagePicker: TTImagePicker?
    ///  弹出ImagePicker
    ///
    ///  - parameter viewController: 当前控制器
    ///  - parameter allowsEditing:  是否需要编辑图片
    ///  - parameter iconView:       当前图片所在View（默认为nil则不展示图片查看功能）
    ///  - parameter finishAction:   选择完图片回调
    class func showImagePickerFromViewController(viewController:UIViewController,allowsEditing:Bool,iconView:UIImageView? = nil,finishAction:(_:UIImage?->Void)) {
        if TTImagePicker.imagePicker == nil {
            TTImagePicker.imagePicker = TTImagePicker()
        }
        TTImagePicker.imagePicker!.showImagePickerFromViewController(viewController, allowsEdited: allowsEditing,iconView: iconView ,callBackAction: finishAction)
    }
}
extension TTImagePicker:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    private func showImagePickerFromViewController(viewC:UIViewController,allowsEdited:Bool,iconView:UIImageView?,callBackAction:(_:UIImage?->Void)){
        finishAction = callBackAction
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if iconView != nil {
            if iconView!.image != nil  {
                sheet.addAction(UIAlertAction(title: "查看大图", style: .Default, handler: { (_) in
                    ImageWatchView.showImageWithIcon(iconView!)
                }))
            }
        }
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            sheet.addAction(UIAlertAction(title: "拍照", style: .Default, handler: { (_) in
                let pickerVc = UIImagePickerController()
                pickerVc.delegate = TTImagePicker.imagePicker
                pickerVc.sourceType = .Camera
                pickerVc.allowsEditing = allowsEdited
                viewC.presentViewController(pickerVc, animated: true, completion: nil)
            }))
        }
        sheet.addAction(UIAlertAction(title: "从相机中选择", style: .Default, handler: { (_) in
            let pickerVc = UIImagePickerController()
            pickerVc.delegate = TTImagePicker.imagePicker
            pickerVc.allowsEditing = allowsEdited
            viewC.presentViewController(pickerVc, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style:.Cancel, handler: { (_) in
            TTImagePicker.imagePicker = nil
        }))
        viewC.presentViewController(sheet, animated: true, completion: nil)
    }
    @objc internal func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var icon = info[UIImagePickerControllerEditedImage] as? UIImage
        if (icon == nil) {
            icon = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        if finishAction != nil {
            finishAction!(icon)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        TTImagePicker.imagePicker = nil
    }
    @objc internal func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        TTImagePicker.imagePicker = nil
    }
}
private class ImageWatchView: UIView,UIScrollViewDelegate {
    var icon : UIImage?{
        didSet{
            if icon != nil {
                self.calculateImageFrameWithImage(icon!)
            }
        }
    }
    var backImageView : UIImageView?
    static func showImageWithIcon(iconView:UIImageView) -> ImageWatchView {
        let browseImagesView = ImageWatchView(frame: UIScreen.mainScreen().bounds)
        browseImagesView.backImageView = iconView
        browseImagesView.initSubviews()
        browseImagesView.icon = iconView.image
        UIApplication.sharedApplication().keyWindow?.addSubview(browseImagesView)
        return browseImagesView
    }
    /// 计算frame
    private func calculateImageFrameWithImage(image:UIImage)  {
        self.getImageView().image = image
        let scaleX = scrollView.bounds.width/image.size.width
        let scaleY = scrollView.bounds.height/image.size.height
        getImageView().frame = backImageView!.frame
        self.backgroundColor =  UIColor(white: 0.8, alpha: 0)
        UIView.animateWithDuration(0.4) {
            self.backgroundColor =  UIColor(white: 0.8, alpha: 0.8)
            if scaleX > scaleY {
                let imgViewWidth = image.size.width * scaleY
                self.getImageView().frame = CGRect(x: 0.5*(self.scrollView.bounds.width-imgViewWidth), y: 0, width: imgViewWidth, height: self.scrollView.bounds.height)
            }else{
                let imgViewHeight = image.size.height*scaleX
                self.getImageView().frame = CGRect(x: 0, y: 0.5*(self.scrollView.bounds.height-imgViewHeight), width: self.scrollView.bounds.width, height: imgViewHeight)
            }
        }
    }
    /// 移除当前浏览器
    private func removeView() {
        UIView.animateWithDuration(0.4, animations: {
            self.getImageView().frame = self.backImageView!.frame
                    self.backgroundColor =  UIColor(white: 0.8, alpha: 0)
        }) { (finished) in
            self.removeFromSuperview()
            self.scrollView.removeFromSuperview()
        }
    }
    private func initSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(getScaleView())
        getScaleView().addSubview(getImageView())
//        UIView.animateWithDuration(0.4) {
//            self.alpha = 0.8
//        }
    }
    @objc private func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scaleView
    }
    private var scaleView : UIView?
    private func getScaleView() -> UIView {
        if scaleView == nil {
            let object = UIView(frame: self.scrollView.frame)
            let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageWatchView.handleTapGesture))
            singleTapGestureRecognizer.numberOfTapsRequired = 1
            object.addGestureRecognizer(singleTapGestureRecognizer)
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageWatchView.handleTapGesture))
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            object.addGestureRecognizer(doubleTapGestureRecognizer)
            singleTapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
            object.backgroundColor = UIColor.clearColor()
            scaleView = object
        }
        return scaleView!
    }
    @objc private func handleTapGesture(sender:UITapGestureRecognizer)  {
        if sender.numberOfTapsRequired == 1 {
            if self.scrollView.zoomScale == self.scrollView.minimumZoomScale {
                removeView()
            }else{
                UIView.animateWithDuration(0.2, animations: {
                    self.scrollView.zoomScale = self.scrollView.minimumZoomScale
                })
            }
            return
        }
        if sender.numberOfTapsRequired == 2 {
            UIView.animateWithDuration(0.2, animations: {
                if self.scrollView.zoomScale <= 1.7{  self.scrollView.zoomScale = self.scrollView.maximumZoomScale}else{self.scrollView.zoomScale = self.scrollView.minimumZoomScale}
            })
        }
    }
    private var imageView : UIImageView?
    func getImageView() -> UIImageView {
        if imageView == nil {
            let object = UIImageView()
            object.clipsToBounds = true
            object.contentMode = .ScaleAspectFill
            imageView = object
        }
        return imageView!
    }
    lazy private  var scrollView: UIScrollView = {
        let object = UIScrollView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)))
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        object.bouncesZoom = true
        object.delegate = self
        object.alwaysBounceVertical = true
        object.alwaysBounceHorizontal = true
        object.minimumZoomScale = 1.0
        object.maximumZoomScale = 2.5
        return object
    }()
    
}

