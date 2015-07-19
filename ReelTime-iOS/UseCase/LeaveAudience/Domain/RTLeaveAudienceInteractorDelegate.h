#import <Foundation/Foundation.h>

@protocol RTLeaveAudienceInteractorDelegate <NSObject>

- (void)leaveAudienceSucceededForReelId:(NSNumber *)reelId;

- (void)leaveAudienceFailedForReelId:(NSNumber *)reelId
                           withError:(NSError *)error;

@end
