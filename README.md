# TTImagePicker

## 使用

~~~python
platform :ios, ‘8.0’ 
use_frameworks!
target "TCImagePickerExample" do
	pod 'TCImagePicker'
end
~~~

```python
pod install
```



## 图片选择器
![](https://raw.githubusercontent.com/itanchao/TTImagePicker/master/TTImagePicker.gif)


一行代码实现拍照，选择，放大功能

```swift
    func imageViewClick(imageView:UIImageView?) {
        TCImagePicker.showImagePickerFromViewController(viewController: self, allowsEditing: true, iconView: self.imageView) { [unowned self](icon) in
            self.imageView.image = icon!
        }
    }
```


