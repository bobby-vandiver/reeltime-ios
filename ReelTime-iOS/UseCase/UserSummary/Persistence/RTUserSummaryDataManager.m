#import "RTUserSummaryDataManager.h"

#import "RTClient.h"
#import "RTLogging.h"

@interface RTUserSummaryDataManager ()

@property RTClient *client;

@end

@implementation RTUserSummaryDataManager

- (instancetype)initWithClient:(RTClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)fetchUserForUsername:(NSString *)username
                   userFound:(UserCallback)userFound
                userNotFound:(NoArgsCallback)userNotFound {

    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to find user %@ with errors %@", username, serverErrors);
        userNotFound();
    };
    
    [self.client userForUsername:username
                         success:userFound
                         failure:failureCallback];
}

@end
