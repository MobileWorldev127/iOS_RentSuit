# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
 use_frameworks!



def common_pods
    pod "TPKeyboardAvoidingSwift"
    pod 'GoogleMaps'
    pod 'Cosmos', '~> 17.0'
    pod 'AFNetworking', '~> 3.0'
    pod 'FBSDKCoreKit', '4.38.1'
    pod 'FBSDKLoginKit', '4.38.1'
    pod 'FBSDKShareKit', '4.38.1'
    pod 'TwitterKit'  , '3.4.2'

end


#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        if target.name == 'TPKeyboardAvoidingSwift'
#            target.build_configurations.each do |config|
#                config.build_settings['ENABLE_BITCODE'] = 'NO'
#                config.build_settings['SWIFT_VERSION'] = '3.2'
#            end
#        end
#    end
#end

target 'RentaSuit' do
    common_pods
end

