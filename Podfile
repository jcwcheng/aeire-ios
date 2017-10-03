platform :ios, '10.0'
source 'https://github.com/CocoaPods/Specs.git'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

target 'SmartDoorBell' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SmartDoorBell
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
  pod 'Moya', '8.0.1'
  pod 'SwiftyJSON'
  pod 'RealmSwift'
  pod 'InteractiveSideMenu'
  # pod 'NVActivityIndicatorView'
  # pod 'Toast-Swift', '~> 2.0.0'
  pod 'ReachabilitySwift', '~> 3'
  # pod 'SwiftMessages'
  # pod 'DeviceLayout'
  # pod 'SwiftMoment'
  pod 'OneSignal', '~> 2.0'

  target 'SmartDoorBellTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'OneSignalNotificationServiceExtension' do
     pod 'OneSignal', '~> 2.0'
  end

end
