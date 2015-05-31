#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTAPIClient;
@class RTUser;

@interface RTUserSummaryDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)fetchUserForUsername:(NSString *)username
                   userFound:(UserCallback)userFound
                userNotFound:(NoArgsCallback)userNotFound;

@end
