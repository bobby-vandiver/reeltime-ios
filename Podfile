platform :ios, '8.0'

target 'ReelTime-iOS', :exclusive => true do
    # Typhoon cannot be linked into the test target
    # See: https://github.com/appsquickly/Typhoon/issues/242
    pod 'Typhoon', '~> 3.2'

    pod 'UICKeyChainStore', '~> 2.0'
    pod 'CocoaLumberjack', '~> 2.0'

    pod 'UIDeviceIdentifier', :git => 'https://github.com/squarefrog/UIDeviceIdentifier.git'
    
    # RestKit uses some deprecated APIs
    pod 'RestKit', '~> 0.25', :inhibit_warnings => true

    # Testing module must be included in the main target
    # to avoid introducing duplicate symbols
    pod 'RestKit/Testing', '~> 0.25', :inhibit_warnings => true
    
    # RestKit dependency that uses deprecated APIs
    pod 'ISO8601DateFormatterValueTransformer', '~> 0.6.1', :inhibit_warnings => true
end

target 'ReelTime-iOSTests' do
    pod 'Specta', '~> 0.5'
    pod 'Expecta', '~> 0.4'
    pod 'OCMockito', '~> 1.4'

    # OCHamcrest has a few cast warnings
    pod 'OCHamcrest', '~> 4.1.1', :inhibit_warnings => true

    # Nocilla has a few conversion warnings
    pod 'Nocilla', '~> 0.9', :inhibit_warnings => true
end
