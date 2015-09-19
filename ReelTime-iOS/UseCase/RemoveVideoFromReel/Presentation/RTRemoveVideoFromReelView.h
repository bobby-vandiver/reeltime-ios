#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@protocol RTRemoveVideoFromReelView <NSObject, RTErrorMessageView>

- (void)showVideoAsRemovedFromReelForVideoId:(NSNumber *)videoId
                                      reelId:(NSNumber *)reelId;

@end
