#import "RTBrowseAllUsersDataManagerDelegate.h"

@implementation RTBrowseAllUsersDataManagerDelegate

- (void)listUsersPage:(NSUInteger)page
           withClient:(RTClient *)client
              success:(UserListCallback)success
              failure:(ServerErrorsCallback)failure {

    [client listUsersPage:page
                  success:success
                  failure:failure];
}

@end
