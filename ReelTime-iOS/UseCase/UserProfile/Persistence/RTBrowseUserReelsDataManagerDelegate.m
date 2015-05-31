#import "RTBrowseUserReelsDataManagerDelegate.h"

@interface RTBrowseUserReelsDataManagerDelegate ()

@property (copy) NSString *username;

@end

@implementation RTBrowseUserReelsDataManagerDelegate

- (instancetype)initWithUsername:(NSString *)username {
    self = [super init];
    if (self) {
        self.username = username;
    }
    return self;
}

- (void)listReelsPage:(NSUInteger)page
           withClient:(RTAPIClient *)client
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure {

    [client listReelsPage:page
      forUserWithUsername:self.username
                  success:success
                  failure:failure];
}

@end
