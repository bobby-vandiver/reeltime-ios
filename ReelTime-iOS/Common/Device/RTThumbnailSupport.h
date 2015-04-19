#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTDeviceInformation;

typedef NS_ENUM(NSInteger, RTThumbnailResolution) {
    RTThumbnailResolution1X,
    RTThumbnailResolution2X,
    RTThumbnailResolution3X
};

@interface RTThumbnailSupport : NSObject

- (instancetype)initWithDeviceInformation:(RTDeviceInformation *)deviceInformation;

- (CGSize)dimensions;

- (RTThumbnailResolution)resolution;

@end
