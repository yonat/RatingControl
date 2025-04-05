Pod::Spec.new do |s|

  s.name         = 'RatingControl'
  s.version      = '1.0.0'
  s.summary      = 'Fully customizable star ratings for iOS'
  s.homepage     = 'https://github.com/yonat/RatingControl'
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }

  s.author       = { 'Yonat Sharon' => 'yonat@ootips.org' }

  s.platform     = :ios, '13.0'
  s.swift_versions = ['5.9']

  s.source       = { :git => 'https://github.com/yonat/RatingControl.git', :tag => s.version }
  s.source_files  = 'Sources/RatingControl/*.swift'
  s.resource_bundles = {s.name => ['Sources/RatingControl/PrivacyInfo.xcprivacy']}

end
