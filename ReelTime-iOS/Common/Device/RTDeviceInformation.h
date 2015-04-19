#import <Foundation/Foundation.h>

@class RTDeviceHardware;

@interface RTDeviceInformation : NSObject

- (instancetype)initWithDeviceHardware:(RTDeviceHardware *)deviceHardware;

- (BOOL)iPhone4;

- (BOOL)iPhone5;

- (BOOL)iPhone6;

- (BOOL)iPhone6Plus;

@end
