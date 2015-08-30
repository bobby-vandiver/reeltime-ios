#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@protocol RTDeleteVideoView <NSObject, RTErrorMessageView>

- (void)showVideoAsDeletedForVideoId:(NSNumber *)videoId;

@end
