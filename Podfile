platform :ios, '8.0'

target 'ReelTime-iOS', :exclusive => true do
    
    # Typhoon cannot be linked into the test target
    # See: https://github.com/appsquickly/Typhoon/issues/242
    #
    # Typhoon emits "Designated initializer should only invoke a designated initializer on 'super'" warning
    pod 'Typhoon', '~> 3.3'

    pod 'UICKeyChainStore', '~> 2.0'

    # CocoaLumberjack emits "Method override for the designated initializer of the superclass '-init' not found" warning
    pod 'CocoaLumberjack', '~> 2.0', :inhibit_warnings => true

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
    # Specta emits "Duplicate protocol definition of 'XCTestObservation' is ignored
    pod 'Specta', '~> 1.0', :inhibit_warnings => true

    pod 'Expecta', '~> 1.0'
    pod 'OCMockito', '~> 1.4'

    # OCHamcrest has a few cast warnings
    pod 'OCHamcrest', '~> 4.1.1', :inhibit_warnings => true

    # Nocilla has a few conversion warnings
    pod 'Nocilla', '~> 0.9', :inhibit_warnings => true
end
