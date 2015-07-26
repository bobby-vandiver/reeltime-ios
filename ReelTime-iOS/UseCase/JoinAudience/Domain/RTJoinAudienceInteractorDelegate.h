#import <Foundation/Foundation.h>

@protocol RTJoinAudienceInteractorDelegate <NSObject>

- (void)joinAudienceSucceededForReelId:(NSNumber *)reelId;

- (void)joinAudienceFailedForReelId:(NSNumber *)reelId
                          withError:(NSError *)error;

@end
