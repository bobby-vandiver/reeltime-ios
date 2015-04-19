#import <Typhoon/Typhoon.h>

@class RTDeviceHardware;
@class RTDeviceInformation;
@class RTThumbnailSupport;

@interface RTDeviceAssembly : TyphoonAssembly

- (RTDeviceHardware *)deviceHardware;

- (RTDeviceInformation *)deviceInformation;

- (RTThumbnailSupport *)thumbnailSupport;

@end
