#import <Foundation/Foundation.h>

@class RTUser;
@class RTReel;
@class RTVideo;

@interface RTNewsfeedWireframe : NSObject

- (void)presentUser:(RTUser *)user;

- (void)presentReel:(RTReel *)reel;

- (void)presentVideo:(RTVideo *)video;

@end
