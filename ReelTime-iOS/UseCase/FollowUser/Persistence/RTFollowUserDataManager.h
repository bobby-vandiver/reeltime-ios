#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTFollowUserDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)followUserWithUsername:(NSString *)username
                 followSuccess:(NoArgsCallback)success
                 followFailure:(ErrorCallback)failure;

@end
