#import <Foundation/Foundation.h>

@protocol RTRemoveVideoFromReelInteractorDelegate <NSObject>

- (void)removeVideoFromReelSucceededForVideoId:(NSNumber *)videoId
                                        reelId:(NSNumber *)reelId;

- (void)removeVideoFromReelFailedForVideoId:(NSNumber *)videoId
                                     reelId:(NSNumber *)reelId
                                  withError:(NSError *)error;

@end
