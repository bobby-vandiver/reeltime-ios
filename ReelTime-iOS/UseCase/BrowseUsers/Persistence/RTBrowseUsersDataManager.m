#import "RTBrowseUsersDataManager.h"
#import "RTClient.h"
#import "RTUserList.h"

@implementation RTBrowseUsersDataManager

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(NSArray *))callback {

    UserListCallback successCallback = ^(RTUserList *userList) {
        callback(userList.users);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        // TODO: Log errors
        callback(@[]);
    };
    
    [self.client listUsersPage:page
                       success:successCallback
                       failure:failureCallback];
}

@end
