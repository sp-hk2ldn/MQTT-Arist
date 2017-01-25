# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'MoscapsuleTest' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'OpenSSL-Universal', '~> 1.0.1.18'
  pod 'Moscapsule', :git => 'https://github.com/flightonary/Moscapsule.git', :branch => 'swift3'
  pod 'SwiftyJSON'

  # Pods for MoscapsuleTest

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
