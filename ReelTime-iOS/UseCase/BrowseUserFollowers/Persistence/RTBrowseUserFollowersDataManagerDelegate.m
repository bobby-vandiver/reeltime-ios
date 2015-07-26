#import "RTBrowseUserFollowersDataManagerDelegate.h"
#import "RTAPIClient.h"

@interface RTBrowseUserFollowersDataManagerDelegate ()

@property (copy) NSString *username;

@end

@implementation RTBrowseUserFollowersDataManagerDelegate

- (instancetype)initWithUsername:(NSString *)username {
    self = [super init];
    if (self) {
        self.username = username;
    }
    return self;
}

- (void)listUsersPage:(NSUInteger)page
           withClient:(RTAPIClient *)client
              success:(UserListCallback)success
              failure:(ServerErrorsCallback)failure {
    
    [client listFollowersPage:page
          forUserWithUsername:self.username
                      success:success
                      failure:failure];
}

@end
