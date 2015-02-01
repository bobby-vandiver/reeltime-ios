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

@property (nonatomic, copy) NSNumber *type;

@property (nonatomic) RTUser *user;
@property (nonatomic) RTReel *reel;
@property (nonatomic) RTVideo *video;

@end
