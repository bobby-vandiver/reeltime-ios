#import "RTBrowseUserFolloweesDataManagerDelegate.h"
#import "RTAPIClient.h"

@interface RTBrowseUserFolloweesDataManagerDelegate ()

@property (copy) NSString *username;

@end

@implementation RTBrowseUserFolloweesDataManagerDelegate

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
    
    [client listFolloweesPage:page
          forUserWithUsername:self.username
                      success:success
                      failure:failure];
}

@end
