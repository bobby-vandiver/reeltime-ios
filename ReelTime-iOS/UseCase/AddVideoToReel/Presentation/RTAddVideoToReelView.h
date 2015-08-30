#import <Foundation/Foundation.h>

@protocol RTAddVideoToReelView <NSObject>

- (void)showVideoAsAddedToReelForVideoId:(NSNumber *)videoId
                                  reelId:(NSNumber *)reelId;

@end
