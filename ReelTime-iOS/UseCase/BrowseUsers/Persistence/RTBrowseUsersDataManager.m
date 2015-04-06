#import "RTBrowseUsersDataManager.h"
#import "RTBrowseUsersDataManagerDelegate.h"
#import "RTClient.h"

#import "RTUserList.h"
#import "RTLogging.h"

@interface RTBrowseUsersDataManager ()

@property id<RTBrowseUsersDataManagerDelegate> delegate;

@end

@implementation RTBrowseUsersDataManager

- (instancetype)initWithDelegate:(id<RTBrowseUsersDataManagerDelegate>)delegate
                          client:(RTClient *)client {
    self = [super initWithClient:client];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(NSArray *))callback {

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
