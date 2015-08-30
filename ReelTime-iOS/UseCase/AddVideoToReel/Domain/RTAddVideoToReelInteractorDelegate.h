#import <Foundation/Foundation.h>

@protocol RTAddVideoToReelInteractorDelegate <NSObject>

- (void)addVideoToReelSucceededForVideoId:(NSNumber *)videoId
                                   reelId:(NSNumber *)reelId;

- (void)addVideoToReelFailedForVideoId:(NSNumber *)videoId
                                reelId:(NSNumber *)reelId
                             withError:(NSError *)error;

@end
