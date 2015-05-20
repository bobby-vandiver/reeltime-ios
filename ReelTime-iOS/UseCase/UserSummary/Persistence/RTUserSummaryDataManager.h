#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTClient;
@class RTUser;

@interface RTUserSummaryDataManager : NSObject

- (instancetype)initWithClient:(RTClient *)client;

- (void)fetchUserForUsername:(NSString *)username
           userFoundCallback:(UserCallback)userFoundCallback
        userNotFoundCallback:(NoArgsCallback)userNotFoundCallback;

@end
