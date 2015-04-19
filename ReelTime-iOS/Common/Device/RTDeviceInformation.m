#import "RTDeviceInformation.h"
#import "RTDeviceHardware.h"

@interface RTDeviceInformation ()

@property RTDeviceHardware *deviceHardware;

@end

@implementation RTDeviceInformation

- (instancetype)initWithDeviceHardware:(RTDeviceHardware *)deviceHardware {
    self = [super init];
    if (self) {
        self.deviceHardware = deviceHardware;
    }
    return self;
}

- (BOOL)iPhone4 {
    NSArray *iPhone4Platforms = @[@"iPhone 4 (GSM)", @"iPhone 4 (GSM Rev A)", @"iPhone 4 (CDMA)", @"iPhone 4S"];
    return [self isPlatformInPlatforms:iPhone4Platforms];
}

- (BOOL)iPhone5 {
    NSArray *iPhone5Platforms = @[@"iPhone 5 (GSM)", @"iPhone 5 (GSM+CDMA)", @"iPhone 5C (GSM)",
                                  @"iPhone 5C (GSM+CDMA)", @"iPhone 5S (GSM)", @"iPhone 5S (GSM+CDMA)"];

    return [self isPlatformInPlatforms:iPhone5Platforms];;
}

- (BOOL)iPhone6 {
    return [self isPlatformInPlatforms:@[@"iPhone 6"]];
}

- (BOOL)iPhone6Plus {
    return [self isPlatformInPlatforms:@[@"iPhone 6 Plus"]];
}

- (BOOL)isPlatformInPlatforms:(NSArray *)platforms {
    NSString *devicePlatform = [self.deviceHardware platformString];
    BOOL match = NO;
    
    for (NSString *platform in platforms) {
        if ([devicePlatform isEqualToString:platform]) {
            match = YES;
        }
    }
    
    return match;
}

@end
