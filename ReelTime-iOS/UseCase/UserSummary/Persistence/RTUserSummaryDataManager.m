#import "RTUserSummaryDataManager.h"
#import "RTUserSummaryDataManagerDelegate.h"

#import "RTClient.h"
#import "RTLogging.h"

@interface RTUserSummaryDataManager ()

@property id<RTUserSummaryDataManagerDelegate> delegate;
@property RTClient *client;

@end

@implementation RTUserSummaryDataManager

- (instancetype)initWithDelegate:(id<RTUserSummaryDataManagerDelegate>)delegate
                          client:(RTClient *)client {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.client = client;
    }
    return self;
}

- (void)fetchUserForUsername:(NSString *)username
                    callback:(UserCallback)callback {
    
    UserCallback successCallback = ^(RTUser *user) {
        callback(user);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to find user %@ with errors %@", username, serverErrors);
        [self.delegate userNotFound];
    };
    
    [self.client userForUsername:username
                         success:successCallback
                         failure:failureCallback];
}

@end
