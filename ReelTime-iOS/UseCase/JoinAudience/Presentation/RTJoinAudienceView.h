#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@protocol RTJoinAudienceView <NSObject, RTErrorMessageView>

- (void)showAudienceAsJoinedForReelId:(NSNumber *)reelId;

@end
