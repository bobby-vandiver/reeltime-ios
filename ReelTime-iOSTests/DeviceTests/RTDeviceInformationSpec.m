#import "RTTestCommon.h"

#import "RTDeviceInformation.h"
#import "RTDeviceHardware.h"

SpecBegin(RTDeviceInformation)

describe(@"device information", ^{
    
    __block RTDeviceInformation *deviceInformation;
    __block RTDeviceHardware *deviceHardware;
    
    NSArray *allPlatforms = @[@"iPhone 1G", @"iPhone 3G", @"iPhone 3GS",
                              @"iPhone 4 (GSM)", @"iPhone 4 (GSM Rev A)", @"iPhone 4 (CDMA)", @"iPhone 4S",
                              @"iPhone 5 (GSM)", @"iPhone 5 (GSM+CDMA)", @"iPhone 5C (GSM)",
                              @"iPhone 5C (GSM+CDMA)", @"iPhone 5S (GSM)", @"iPhone 5S (GSM+CDMA)",
                              @"iPhone 6 Plus", @"iPhone 6",
                              @"iPod Touch 1G", @"iPod Touch 2G", @"iPod Touch 3G", @"iPod Touch 4G", @"iPod Touch 5G",
                              @"iPad 1", @"iPad 2 (WiFi)", @"iPad 2 (GSM)", @"iPad 2 (CDMA)", @"iPad 2",
                              @"iPad Mini (WiFi)", @"iPad Mini (GSM)",@"iPad Mini (GSM+CDMA)",
                              @"iPad 3 (WiFi)", @"iPad 3 (GSM+CDMA)", @"iPad 3 (GSM)",
                              @"iPad 4 (WiFi)", @"iPad 4 (GSM)", @"iPad 4 (GSM+CDMA)",
                              @"iPad Air (WiFi)", @"iPad Air (WiFi/Cellular)", @"iPad Air (China)",
                              @"iPad Mini Retina (WiFi)", @"iPad Mini Retina (WiFi/Cellular)", @"iPad Mini Retina (China)",
                              @"iPad Mini 3 (WiFi)", @"iPad Mini 3 (WiFi/Cellular)",
                              
                              @"iPad Air 2 (WiFi)", @"iPad Air 2 (WiFi/Cellular)",

                              @"Simulator", @"Simulator"
                              ];
    
    beforeEach(^{
        deviceHardware = mock([RTDeviceHardware class]);
        deviceInformation = [[RTDeviceInformation alloc] initWithDeviceHardware:deviceHardware];
    });
    
    describe(@"model identifiers", ^{
        
        __block NSMutableArray *invalidPlatforms;
        
        beforeEach(^{
            invalidPlatforms = [allPlatforms mutableCopy];
        });
        
        void (^filterInvalidPlatforms)(NSArray *) = ^(NSArray *platformsToRemove) {
            for (NSString *platform in platformsToRemove) {
                [invalidPlatforms removeObject:platform];
            }
        };
        
        #define testIdentifier(stubPlatform, method, expected)                      \
            do {                                                                    \
                [given([deviceHardware platformString]) willReturn:stubPlatform];   \
                BOOL actual = [deviceInformation method];                           \
                expect(actual).to.equal(expected);                                  \
            } while (0)

        
        #define testMultiplePlatforms(platforms, method, expected)      \
            do {                                                        \
                for (NSString *platform in platforms) {                 \
                    testIdentifier(platform, method, expected);         \
                }                                                       \
            } while(0)
        
        describe(@"iPhone 4", ^{
            NSArray *iPhone4Platforms = @[@"iPhone 4 (GSM)", @"iPhone 4 (GSM Rev A)", @"iPhone 4 (CDMA)", @"iPhone 4S"];
            
            it(@"device is an iPhone 4", ^{
                testMultiplePlatforms(iPhone4Platforms, iPhone4, YES);
            });
            
            it(@"device is not an iPhone 4", ^{
                filterInvalidPlatforms(iPhone4Platforms);
                testMultiplePlatforms(invalidPlatforms, iPhone4, NO);
            });
        });
        
        describe(@"iPhone 5", ^{
            NSArray *iPhone5Platforms = @[@"iPhone 5 (GSM)", @"iPhone 5 (GSM+CDMA)", @"iPhone 5C (GSM)",
                                          @"iPhone 5C (GSM+CDMA)", @"iPhone 5S (GSM)", @"iPhone 5S (GSM+CDMA)"];
            
            it(@"device is an iPhone 5", ^{
                testMultiplePlatforms(iPhone5Platforms, iPhone5, YES);
            });
            
            it(@"device is not an iPhone 5", ^{
                filterInvalidPlatforms(iPhone5Platforms);
                testMultiplePlatforms(invalidPlatforms, iPhone5, NO);
            });
        });
        
        describe(@"iPhone 6", ^{
            NSString *const iPhone6Platform = @"iPhone 6";
            
            it(@"device is an iPhone 6", ^{
                testIdentifier(iPhone6Platform, iPhone6, YES);
            });
            
            it(@"device is not an iPhone 6", ^{
                [invalidPlatforms removeObject:iPhone6Platform];
                testMultiplePlatforms(invalidPlatforms, iPhone6, NO);
            });
        });
        
        describe(@"iPhone 6 Plus", ^{
            NSString *const iPhone6PlusPlatform = @"iPhone 6 Plus";
            
            it(@"device is an iPhone 6 Plus", ^{
                testIdentifier(iPhone6PlusPlatform, iPhone6Plus, YES);
            });
            
            it(@"device is not an iPhone 6 Plus", ^{
                [invalidPlatforms removeObject:iPhone6PlusPlatform];
                testMultiplePlatforms(invalidPlatforms, iPhone6Plus, NO);
            });
        });
    });
});

SpecEnd
