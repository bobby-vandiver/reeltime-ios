#import "RTDeviceHardware.h"

@implementation RTDeviceHardware

- (NSString *)platform {
    return [UIDeviceHardware platform];
}

- (NSString *)platformString {
    return [UIDeviceHardware platformString];
}

@end
