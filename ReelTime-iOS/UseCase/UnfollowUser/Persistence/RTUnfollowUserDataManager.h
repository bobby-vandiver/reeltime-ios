#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTUnfollowUserDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)unfollowUserWithUsername:(NSString *)username
                 unfollowSuccess:(NoArgsCallback)success
                 unfollowFailure:(ErrorCallback)failure;

@end
