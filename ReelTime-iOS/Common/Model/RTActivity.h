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

+ (RTActivity *)createReelActivityWithUser:(RTUser *)user
                                      reel:(RTReel *)reel;

+ (RTActivity *)joinReelActivityWithUser:(RTUser *)user
                                    reel:(RTReel *)reel;

+ (RTActivity *)addVideoToReelActivityWithUser:(RTUser *)user
                                          reel:(RTReel *)reel
                                         video:(RTVideo *)video;

@end
