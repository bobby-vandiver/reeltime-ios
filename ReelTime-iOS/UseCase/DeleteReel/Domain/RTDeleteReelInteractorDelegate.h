#import <Foundation/Foundation.h>

@protocol RTDeleteReelInteractorDelegate <NSObject>

- (void)deleteReelSucceededForReelId:(NSNumber *)reelId;

- (void)deleteReelFailedForReelId:(NSNumber *)reelId
                        withError:(NSError *)error;

@end
