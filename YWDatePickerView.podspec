
Pod::Spec.new do |spec|

  spec.name         = 'YWDatePickerView'
  spec.version      = '0.0.1'
  spec.summary      = '简单易用的日期选择控件'
  spec.description  = 'YWDatePickerView包含页面弹出和输入框InputView两种展现形式，简单易用。'

  spec.homepage     = 'https://github.com/longwu-yw'

  spec.license      = 'MIT'
  spec.author       = { 'Wang Ye' => 'longwu_ye@outlook.com' }
 
  spec.source       = { :git => 'https://github.com/longwu-yw/YWDatePickerView.git', :tag => spec.version }
  spec.source_files  = 'YWDatePickerView/*.{swift}'
  spec.platform	   = :ios, '11.0'
  spec.requires_arc = true
  spec.swift_version = '5.0'

end
