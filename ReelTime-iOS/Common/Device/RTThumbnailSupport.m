#import "RTThumbnailSupport.h"
#import "RTDeviceInformation.h"

@interface RTThumbnailSupport ()

@property RTDeviceInformation *deviceInformation;

@end

@implementation RTThumbnailSupport

- (instancetype)initWithDeviceInformation:(RTDeviceInformation *)deviceInformation {
    self = [super init];
    if (self) {
        self.deviceInformation = deviceInformation;
    }
    return self;
}

- (CGSize)dimensions {
    if ([self deviceSupportsResolution3X]) {
        return CGSizeMake(225, 225);
    }
    else if ([self deviceSupportsResolution2X]) {
        return CGSizeMake(150, 150);
    }
    return CGSizeMake(75, 75);
}

- (RTThumbnailResolution)resolution {
    if ([self deviceSupportsResolution3X]) {
        return RTThumbnailResolution3X;
    }
    else if ([self deviceSupportsResolution2X]) {
        return RTThumbnailResolution2X;
    }    
    return RTThumbnailResolution1X;
}

- (BOOL)deviceSupportsResolution2X {
    return self.deviceInformation.iPhone4 || self.deviceInformation.iPhone5 || self.deviceInformation.iPhone6;
}

- (BOOL)deviceSupportsResolution3X {
    return self.deviceInformation.iPhone6Plus;
}

@end
