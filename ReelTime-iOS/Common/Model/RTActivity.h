#import <Foundation/Foundation.h>

@class RTUser;
@class RTReel;
@class RTVideo;

typedef NS_ENUM(NSInteger, RTActivityType) {
    RTActivityTypeCreateReel,
    RTActivityTypeJoinReelAudience,
    RTActivityTypeAddVideoToReel
};

@interface RTActivity : NSObject

@property (nonatomic, assign) RTActivityType type;

@property (nonatomic, copy) RTUser *user;
@property (nonatomic, copy) RTReel *reel;
@property (nonatomic, copy) RTVideo *video;

@end
