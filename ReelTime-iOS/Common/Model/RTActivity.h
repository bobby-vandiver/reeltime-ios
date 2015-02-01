#import <Foundation/Foundation.h>

@class RTUser;
@class RTReel;
@class RTVideo;

typedef NS_ENUM(NSInteger, RTActivityType) {
    ActivityCreateReel,
    ActivityJoinReelAudience,
    ActivityAddVideoToReel
};

@interface RTActivity : NSObject

@property (nonatomic, copy) NSNumber *type;

@property (nonatomic, copy) RTUser *user;
@property (nonatomic, copy) RTReel *reel;
@property (nonatomic, copy) RTVideo *video;

@end
