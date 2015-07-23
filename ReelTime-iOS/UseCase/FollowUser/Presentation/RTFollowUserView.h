#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@protocol RTFollowUserView <NSObject, RTErrorMessageView>

- (void)showUserAsFollowedForUsername:(NSString *)username;

@end
