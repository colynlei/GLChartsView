#
#  Be sure to run `pod spec lint GLChartsView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "GLChartsView"
  s.version      = "1.2.9"
  s.summary      = "封装折线图，可高度自定义，线宽，坐标轴，网格线，折线线宽，折线颜色，折线动画，焦点动画，焦点视图等"
  s.description  = <<-DESC 
                          GLChartsView 是一个简单封装的折线图框架
                   DESC
  s.homepage     = "https://github.com/colynlei/GLChartsView"
  s.license      = "MIT"
  s.author       = { "『国』" => "leiguolinhaoshuai@163.com" }
  s.source       = { :git => "https://github.com/colynlei/GLChartsView.git", :tag => "#{s.version}" }
  s.source_files = "Classes", "GLChartsView/*.{h,m}"
  s.ios.deployment_target = "9.0"
  s.requires_arc = true
  s.dependency 'YYKit'


end
