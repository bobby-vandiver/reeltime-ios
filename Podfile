platform :ios, '8.0'

target 'ReelTime-iOS', :exclusive => true do
    # Typhoon cannot be linked into the test target
    # See: https://github.com/appsquickly/Typhoon/issues/242
    pod 'Typhoon', '~> 2.3'

    pod 'UICKeyChainStore', '~> 1.1.0'
    
    # RestKit uses some deprecated APIs
    pod 'RestKit', '~> 0.24.0', :inhibit_warnings => true
    
    # RestKit dependency that uses deprecated APIs
    pod 'ISO8601DateFormatterValueTransformer', '~> 0.6.0', :inhibit_warnings => true
end

target 'ReelTime-iOSTests' do
    pod 'Specta', :git => 'https://github.com/specta/specta.git', :tag => 'v0.3.0.beta1'
    pod 'Expecta', '~> 0.3.1'
    pod 'OCMockito', '~> 1.3.1'
end
