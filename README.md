# TTImagePicker
## 图片选择器
![](https://raw.githubusercontent.com/itanchao/TTImagePicker/master/TTImagePicker.gif)


一行代码实现拍照，选择，放大功能

```js
    func imageViewClick(imageView:UIImageView?) {
        TTImagePicker.showImagePickerFromViewController(self, allowsEditing: true, iconView: self.imageView) { (icon) in
            self.imageView.image = icon!
        }
    }
```


