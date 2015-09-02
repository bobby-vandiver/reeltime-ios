#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@protocol RTDeleteReelView <NSObject, RTErrorMessageView>

- (void)showReelAsDeletedForReelId:(NSNumber *)reelId;

@end
