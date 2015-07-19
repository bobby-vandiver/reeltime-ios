#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@protocol RTLeaveAudienceView <NSObject, RTErrorMessageView>

- (void)showAudienceAsNotJoinedForReelId:(NSNumber *)reelId;


@end
