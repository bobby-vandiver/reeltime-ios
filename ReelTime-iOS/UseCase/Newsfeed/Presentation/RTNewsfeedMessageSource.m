#import "RTNewsfeedMessageSource.h"
#import "RTActivityMessage.h"

#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

@implementation RTNewsfeedMessageSource

+ (NSString *)messageFormatForActivityType:(NSNumber *)type {
    NSDictionary *messageFormatsForActivites = @{
                                                 @(RTActivityTypeCreateReel): @"%@ created the %@ reel",
                                                 @(RTActivityTypeJoinReelAudience): @"%@ joined the audience of the %@ reel",
                                                 @(RTActivityTypeAddVideoToReel): @"%@ added the video %@ to the %@ reel"
                                                 };
    
    return messageFormatsForActivites[type];
}

- (RTActivityMessage *)messageForActivity:(RTActivity *)activity {
    RTUser *user = activity.user;
    RTReel *reel = activity.reel;
    RTVideo *video = activity.video;
    
    NSString *text = [self textForActivity:activity];
    RTActivityType type = [activity.type integerValue];
    
    return [RTActivityMessage activityMessageWithText:text
                                                 type:type
                                          forUsername:user.username
                                               reelId:reel.reelId
                                              videoId:video.videoId];
}

- (NSString *)textForActivity:(RTActivity *)activity {
    NSString *username = activity.user.username;
    NSString *reelName = activity.reel.name;
    NSString *videoTitle = activity.video.title;
    
    NSString *format = [RTNewsfeedMessageSource messageFormatForActivityType:activity.type];
    NSString *text;
    
    if ([activity.type isEqual:@(RTActivityTypeAddVideoToReel)]) {
        text = [NSString stringWithFormat:format, username, videoTitle, reelName];
    }
    else {
        text = [NSString stringWithFormat:format, username, reelName];
    }
    
    return text;
}

@end
