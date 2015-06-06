#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;
@class RTUser;

@interface RTUserSummaryDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)fetchUserForUsername:(NSString *)username
                   userFound:(UserCallback)userFound
                userNotFound:(NoArgsCallback)userNotFound;

@end
