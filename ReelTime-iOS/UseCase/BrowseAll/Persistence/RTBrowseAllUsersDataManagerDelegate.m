#import "RTBrowseAllUsersDataManagerDelegate.h"

@implementation RTBrowseAllUsersDataManagerDelegate

- (void)listUsersPage:(NSUInteger)page
           withClient:(RTAPIClient *)client
              success:(UserListCallback)success
              failure:(ServerErrorsCallback)failure {

    [client listUsersPage:page
                  success:success
                  failure:failure];
}

@end
