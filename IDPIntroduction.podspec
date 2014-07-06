Pod::Spec.new do |s|

  s.name         = "IDPIntroduction"
  s.version      = "0.0.1"
  s.summary      = "IDPIntroduction provides a screen to introduce the iPhone app. "

  s.description  = <<-DESC
                   IDPIntroduction provides a screen to introduce the iPhone app. I will customize the introductory statement in the resource-based nib. corresponding iOS7 later. the iPhone, iPad not supported.
[Japanese] IDPIntroduction はiPhoneアプリを紹介するための画面を提供します。nibリソースベースで紹介文をカスタマイズします。iOS7以降対応。iPhone対応、iPad未対応。
                   DESC

  s.homepage     = "https://github.com/notoroid/IDPIntroduction"
  s.screenshots  = "https://raw.githubusercontent.com/notoroid/IDPIntroduction/master/ScreenShots/ss01.png", "https://raw.githubusercontent.com/notoroid/IDPIntroduction/master/ScreenShots/ss02.png"


  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "notoroid" => "noto@irimasu.com" }
  s.social_media_url   = "http://twitter.com/notoroid"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/notoroid/IDPIntroduction.git", :tag => "v0.0.1" }

  s.source_files  = "Lib/**/*.{h,m}"
  s.public_header_files = "Lib/**/*.h"

  s.requires_arc = true

end
