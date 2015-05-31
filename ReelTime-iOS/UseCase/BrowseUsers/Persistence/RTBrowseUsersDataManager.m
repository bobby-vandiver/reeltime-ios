#import "RTBrowseUsersDataManager.h"
#import "RTBrowseUsersDataManagerDelegate.h"
#import "RTAPIClient.h"

#import "RTUserList.h"
#import "RTLogging.h"

@interface RTBrowseUsersDataManager ()

@property id<RTBrowseUsersDataManagerDelegate> delegate;

@end

@implementation RTBrowseUsersDataManager

- (instancetype)initWithDelegate:(id<RTBrowseUsersDataManagerDelegate>)delegate
                          client:(RTAPIClient *)client {
    self = [super initWithClient:client];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)retrievePage:(NSUInteger)page
            callback:(ArrayCallback)callback {

    UserListCallback successCallback = ^(RTUserList *userList) {
        callback(userList.users);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to retrieve user list: %@", serverErrors);
        callback(@[]);
    };
    
    [self.delegate listUsersPage:page
                      withClient:self.client
                         success:successCallback
                         failure:failureCallback];
}

@end
