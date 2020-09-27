#
# Be sure to run `pod lib lint HCSaftiveParam.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HCSaftiveParam'
  s.version          = '0.0.2'
  s.summary          = ' category that avoid some Array or NSDictory has nil value or key,is will cause app crash'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'cateory'

  s.homepage         = 'https://github.com/FredHsuForJava/HCSaftiveParam'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xuwenfeng' => 'xuwf@bsoft.com.cn' }
  s.source           = { :git => 'https://github.com/FredHsuForJava/HCSaftiveParam.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'HCSaftiveParam', 'HCSaftiveParam/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'HCSaftiveParam' => ['HCSaftiveParam/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
