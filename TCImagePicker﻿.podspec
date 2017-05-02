Pod::Spec.new do |s|
s.name         = "TCImagePicker"
s.version      = "1.0.2"
s.summary      = "一行代码实现拍照，选取图片放大图片等功能"
s.homepage     = "https://github.com/itanchao/TCImagePicker"
#s.screenshots  = "./演示.gif"
s.license      = "MIT"
s.author       = { "谈超" => "itanchao@gmail.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/itanchao/TCImagePicker.git", :tag => s.version }
s.source_files  = "Sauces", "Sauces/*.swift"
