platform :ios, '8.0'

target 'ReelTime-iOS', :exclusive => true do
    # Typhoon cannot be linked into the test target
    # See: https://github.com/appsquickly/Typhoon/issues/242
    pod 'Typhoon', '~> 2.3'

    pod 'UICKeyChainStore', '~> 2.0'
    pod 'CocoaLumberjack', '~> 2.0.0-rc'
    pod 'TTTAttributedLabel', '~> 1.13'
    
    # RestKit uses some deprecated APIs
    pod 'RestKit', '~> 0.24.0', :inhibit_warnings => true

    # Testing module must be included in the main target
    # to avoid introducing duplicate symbols
    pod 'RestKit/Testing', '~> 0.24.0', :inhibit_warnings => true
    
    # RestKit dependency that uses deprecated APIs
    pod 'ISO8601DateFormatterValueTransformer', '~> 0.6.0', :inhibit_warnings => true
end

target 'ReelTime-iOSTests' do
    pod 'Specta', '~> 0.3'
    pod 'Expecta', '~> 0.3'
    pod 'OCMockito', '~> 1.4'

    # Nocilla has a few conversion warnings
    pod 'Nocilla', '~> 0.9', :inhibit_warnings => true
end
