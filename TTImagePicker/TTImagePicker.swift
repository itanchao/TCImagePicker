//
//  TTImagePicker.swift
//  TTImagePicker
//
//  Created by wzh on 16/6/2.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit

class TTImagePicker: NSObject {
//    let watchStr = "查看大图"
    let string1 = "拍照"
    let string2 = "从相机中选择"
    var finishAction:((UIImage?)->Void)?
    private static var imagePicker: TTImagePicker?
    class func showImagePickerFromViewController(viewController:UIViewController,allowsEditing:Bool,finishAction:(_:UIImage?->Void)) {
        if TTImagePicker.imagePicker == nil {
            TTImagePicker.imagePicker = TTImagePicker()
        }
        TTImagePicker.imagePicker!.showImagePickerFromViewController(viewController, allowsEdited: allowsEditing, callBackAction: finishAction)
    }
}
extension TTImagePicker:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    private func showImagePickerFromViewController(viewC:UIViewController,allowsEdited:Bool,callBackAction:(_:UIImage?->Void)){
        finishAction = callBackAction;
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            sheet.addAction(UIAlertAction(title: string1, style: .Default, handler: { (_) in
                let pickerVc = UIImagePickerController()
                pickerVc.delegate = TTImagePicker.imagePicker
                pickerVc.sourceType = .Camera
                pickerVc.allowsEditing = allowsEdited
                viewC.presentViewController(pickerVc, animated: true, completion: nil)
            }))
        }
        sheet.addAction(UIAlertAction(title: string2, style: .Default, handler: { (_) in
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if finishAction != nil {
            finishAction!(image)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        TTImagePicker.imagePicker = nil
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
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
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        TTImagePicker.imagePicker = nil
    }
}
