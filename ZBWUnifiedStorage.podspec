#
#  Be sure to run `pod spec lint ZBWUnifiedStorage.spec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "ZBWUnifiedStorage"
  s.version      = "0.0.6"
  s.summary      = "iOS 统一存储库"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC 
                    统一存储，支持多种形式的持久化和内存存储方式，使用统一的API调用方式，降低各种存储方式的使用成本，提高效率。
                    支持NSUserDefaults、NSCache、归档、钥匙串keychain等存储方式;
                    支持过期时间设置;
                    存储路径从 cache目录改成document目录
                   DESC

  s.homepage     = "https://github.com/HangZhouShuChengKeJi/ZBWUnifiedStorage"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "BSD"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.platform     = :ios, "7.0"
  s.author             = { "bwzhu" => "bowen.zhu@91chengguo.com" }


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/HangZhouShuChengKeJi/ZBWUnifiedStorage.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  #s.public_header_files = "ZBWUnifiedStorage/**/ZBWUnifiedStorage*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  #s.resources = "**/ZBWUnifiedStorage.bundle"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.default_subspecs = 'UnifiedStorage'

  # s.subspec 'Model' do |modelSpec|
  #   modelSpec.source_files = 'ZBWUnifiedStorage/Model/*.{h,m}'
  # end

  # s.subspec 'Utility' do |utilitySpec|
  #   utilitySpec.source_files = 'ZBWUnifiedStorage/Utility/*.{h,m}'
  # end

  # s.subspec 'Storage' do |storageSpec|
  #   storageSpec.source_files = 'ZBWUnifiedStorage/Storage/*.{h,m}'
  # end

  s.subspec 'UnifiedStorage' do |usSpec|
    usSpec.source_files = "ZBWUnifiedStorage/ZBWUnifiedStorage.{h,m}","ZBWUnifiedStorage/**/*.{h,m}"
  # usSpec.dependency 'ZBWUnifiedStorage/Model'
  # usSpec.dependency 'ZBWUnifiedStorage/Utility'
  # usSpec.dependency 'ZBWUnifiedStorage/Storage'
  end

  s.subspec 'UserDefaultsCompatible' do |udcSpec|
    udcSpec.source_files = 'ZBWUnifiedStorage/UserDefaultsCompatible/*.{h,m}'
    udcSpec.dependency 'ZBWUnifiedStorage/UnifiedStorage'
    udcSpec.xcconfig = { 
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ZBW_US_Compatible_UserDefaults=1'
    }
  end

  s.requires_arc = true
  # s.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>' #,'#import <ZBWUSDefine.h>'

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "SSKeychain", "1.4.0"

end
