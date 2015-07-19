#import <Foundation/Foundation.h>

@protocol RTJoinAudienceInteractorDelegate <NSObject>

- (void)joinAudienceSucceedForReelId:(NSNumber *)reelId;

- (void)joinAudienceFailedForReelId:(NSNumber *)reelId
                          withError:(NSError *)error;

@end
