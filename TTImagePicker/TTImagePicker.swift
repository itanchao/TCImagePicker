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
    var viewController:UIViewController?
    var finishAction:((UIImage?)->Void)?
    var imageWatcherAction:(()->Void)?
    var allowsEditing : Bool = false
    
    private static var imagePicker: TTImagePicker?
    class func showImagePickerFromViewController(viewController:UIViewController,allowsEditing:Bool,imageWatcherAction:(_: ()->Void),finishAction:(_:UIImage?->Void)) {
        var picker = TTImagePicker.imagePicker
        if picker == nil {
            picker = TTImagePicker()
        }
        picker!.showImagePickerFromViewController(viewController, allowsEdited: allowsEditing, imageWAction: imageWatcherAction, callBackAction: finishAction)
    }
}
extension TTImagePicker:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    private func showImagePickerFromViewController(viewC:UIViewController,allowsEdited:Bool,imageWAction:(_: ()->Void),callBackAction:(_:UIImage?->Void)){
        viewController = viewC
        finishAction = callBackAction;
        allowsEditing = allowsEdited
        imageWatcherAction = imageWAction
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            sheet.addAction(UIAlertAction(title: string1, style: .Default, handler: { (action) in
                print(self.string1)
                let pickerVc = UIImagePickerController()
                pickerVc.delegate = self
                pickerVc.sourceType = .Camera
                pickerVc.allowsEditing = allowsEdited
                viewC.presentViewController(pickerVc, animated: true, completion: nil)
            }))
        }
        sheet.addAction(UIAlertAction(title: string2, style: .Default, handler: { (action) in
            let pickerVc = UIImagePickerController()
            pickerVc.delegate = self
            pickerVc.allowsEditing = allowsEdited
            viewC.presentViewController(pickerVc, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style:.Cancel, handler: { (action) in
            print("取消")
        }))
        viewC.presentViewController(sheet, animated: true, completion: nil)
//         UIAlertController(title: nil, message: "取消", preferredStyle: .ActionSheet)
//        var sheet:UIActionSheet?
//        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
//            sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: string1, string2)
//        }else{
//            sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles:string2)
//        }
//        sheet?.showInView(UIApplication.sharedApplication().keyWindow!)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
    }
    
}
