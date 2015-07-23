#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@protocol RTUnfollowUserView <NSObject, RTErrorMessageView>

- (void)showUserAsUnfollowedForUsername:(NSString *)username;

@end
