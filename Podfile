platform :ios, '8.0'
xcodeproj 'ReelTime-iOS'

pod 'Typhoon', '~> 2.3'
pod 'UICKeyChainStore', '~> 1.1.0'

# RestKit uses some deprecated APIs
pod 'RestKit', '~> 0.24.0', :inhibit_warnings => true

# RestKit dependency that uses deprecated APIs
pod 'ISO8601DateFormatterValueTransformer', '~> 0.6.0', :inhibit_warnings => true

target 'ReelTime-iOSTests' do
    pod 'Specta', :git => 'https://github.com/specta/specta.git', :tag => 'v0.3.0.beta1'
    pod 'Expecta', '~> 0.3.1'
    pod 'OCMock', '~> 3.1.1'
end
