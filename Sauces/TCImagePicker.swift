//
//  TTImagePicker.swift
//  TTImagePicker
//
//  Created by tanchao的iMac on 2016/10/20.
//  Copyright © 2016年 tanchao. All rights reserved.
//

import UIKit

open class TCImagePicker: NSObject {
    ///  回调闭包
    ///
    ///  - returns: 回调闭包
    var finishAction:((UIImage?)->Void)?
    
    static  var picker: TTImagePicker?
    ///  弹出ImagePicker
    ///
    ///  - parameter viewController: 当前控制器
    ///  - parameter allowsEditing:  是否需要编辑图片
    ///  - parameter iconView:       当前图片所在View（默认为nil则不展示图片查看功能）
    ///  - parameter finishAction:   选择完图片回调
    open class func showImagePickerFromViewController(viewController:UIViewController,allowsEditing:Bool,iconView:UIImageView? = nil,finishAction:(_:(UIImage?)->Void)) {
        if picker == nil {
            picker = TTImagePicker()
        }
        picker?.showImagePickerFromViewController(viewC: viewController, allowsEdited: allowsEditing, iconView: iconView, callBackAction: finishAction)
    }
}
extension TTImagePicker:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   open func showImagePickerFromViewController(viewC:UIViewController,allowsEdited:Bool,iconView:UIImageView?,callBackAction:(_:(UIImage?)->Void)){
        finishAction = callBackAction
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if iconView != nil {
            if iconView!.image != nil  {
                sheet.addAction(UIAlertAction(title: "查看大图", style: .default, handler: { (_) in
                    ImageWatchView.showImageWithIcon(iconView: iconView!, fromVc: viewC)
                }))
            }
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (_) in
                let imagePickerVc = UIImagePickerController()
                imagePickerVc.delegate = TTImagePicker.picker
                imagePickerVc.sourceType = .camera
                imagePickerVc.allowsEditing = allowsEdited
                viewC.present(imagePickerVc, animated: true, completion: nil)
            }))
        }
        
        sheet.addAction(UIAlertAction(title: "从相机中选择", style: .default, handler: { (_) in
            let imagePickerVc = UIImagePickerController()
            imagePickerVc.delegate = TTImagePicker.picker
            imagePickerVc.allowsEditing = allowsEdited
            viewC.present(imagePickerVc, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style:.cancel, handler: { (_) in
            TTImagePicker.picker = nil
        }))
        viewC.present(sheet, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var icon = info[UIImagePickerControllerEditedImage] as? UIImage
        if (icon == nil) {
            icon = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        if finishAction != nil {
            finishAction!(icon)
        }
        picker.dismiss(animated: true, completion: nil)
        TTImagePicker.picker = nil
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        TTImagePicker.picker = nil
        
    }
}
private class ImageWatchView: UIView,UIScrollViewDelegate {
    var icon : UIImage?{
        didSet{
            if icon != nil {
                calculateImageFrameWithImage(image: icon!)
            }
        }
    }
    var backImageView : UIImageView?
    var currentVC : UIViewController?
    
    class func showImageWithIcon(iconView:UIImageView,fromVc:UIViewController) {
        let browseImagesView = ImageWatchView(frame: UIScreen.main.bounds)
        browseImagesView.backImageView = iconView
        browseImagesView.initSubviews()
        browseImagesView.icon = iconView.image
        browseImagesView.currentVC = fromVc
        fromVc.view.addSubview(browseImagesView)
    }
    /// 计算frame
    private func calculateImageFrameWithImage(image:UIImage)  {
        self.getImageView().image = image
        let scaleX = scrollView.bounds.width/image.size.width
        let scaleY = scrollView.bounds.height/image.size.height
        getImageView().frame = backImageView!.frame
        self.backgroundColor =  UIColor(white: 0.8, alpha: 0)
         UIView.animate(withDuration: 0.4) {
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
         UIView.animate(withDuration: 0.4, animations: {
            self.getImageView().frame = self.backImageView!.frame
                    self.backgroundColor =  UIColor(white: 0.8, alpha: 0)
        }) { (finished) in
            self.removeFromSuperview()
            self.scrollView.removeFromSuperview()
            TTImagePicker.picker = nil;
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
     @nonobjc func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
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
            singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
            object.backgroundColor = UIColor.clear
            scaleView = object
        }
        return scaleView!
    }
    @objc private func handleTapGesture(sender:UITapGestureRecognizer)  {
        if sender.numberOfTapsRequired == 1 {
            if self.scrollView.zoomScale == self.scrollView.minimumZoomScale {
                removeView()
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.scrollView.zoomScale = self.scrollView.minimumZoomScale
                })
            }
            return
        }
        if sender.numberOfTapsRequired == 2 {
            UIView.animate(withDuration: 0.2, animations: { 
                  if self.scrollView.zoomScale <= 1.7{  self.scrollView.zoomScale = self.scrollView.maximumZoomScale}else{self.scrollView.zoomScale = self.scrollView.minimumZoomScale}
            })
        }
    }
    private var imageView : UIImageView?
    func getImageView() -> UIImageView {
        if imageView == nil {
            let object = UIImageView()
            object.clipsToBounds = true
            object.contentMode = .scaleAspectFill
            imageView = object
//            imageView!.addOnClickListener(self, action: #selector(ImageWatchView.showSaveButton))
            let longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ImageWatchView.showSaveButton))
            longTapGestureRecognizer.minimumPressDuration = 0.5
            imageView!.isUserInteractionEnabled = true
            imageView!.addGestureRecognizer(longTapGestureRecognizer)
            
        }
        return imageView!
    }
    var saveButtonShowed = false
    
    @objc  func showSaveButton() {
        if getImageView().image == nil { return }
        if saveButtonShowed { return }
        saveButtonShowed = true
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "保存", style: .default, handler: {[unowned self] (_) in
            self.saveButtonShowed = false
            UIImageWriteToSavedPhotosAlbum(self.icon!, nil, nil, nil)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { [unowned self] (_) in
            self.saveButtonShowed = false
        }))
        currentVC!.present(sheet, animated: true, completion: nil)
    }
    lazy private  var scrollView: UIScrollView = {
        let object = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
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

