#
# Be sure to run `pod lib lint Test.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Flowplayer'
  s.version          = '0.1.2'
  s.summary          = 'Flowplayer iOS SDK'
  s.author           = { 'Mathias Palm' => 'mathias.palm@appshack.se' }
  s.homepage         = 'https://flowplayer.com'
  s.license          = "MIT"
  s.platform         = :ios, "10.0"
  s.source           = { :git => "https://github.com/flowplayer/flowplayer-ios-sdk.git", :tag => s.version }
  s.source_files     = "Flowplayer", "Flowplayer/**/*.{h,m,swift}"

end
