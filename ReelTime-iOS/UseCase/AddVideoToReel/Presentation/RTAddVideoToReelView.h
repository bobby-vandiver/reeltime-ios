#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@protocol RTAddVideoToReelView <NSObject, RTErrorMessageView>

- (void)showVideoAsAddedToReelForVideoId:(NSNumber *)videoId
                                  reelId:(NSNumber *)reelId;

@end
