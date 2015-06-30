#import "RTBrowseAudienceMembersDataManagerDelegate.h"
#import "RTAPIClient.h"

@interface RTBrowseAudienceMembersDataManagerDelegate ()

@property (copy) NSNumber *reelId;

@end

@implementation RTBrowseAudienceMembersDataManagerDelegate

- (instancetype)initWithReelId:(NSNumber *)reelId {
    self = [super init];
    if (self) {
        self.reelId = reelId;
    }
    return self;
}

- (void)listUsersPage:(NSUInteger)page
           withClient:(RTAPIClient *)client
              success:(UserListCallback)success
              failure:(ServerErrorsCallback)failure {
    
    [client listAudienceMembersPage:page
                  forReelWithReelId:[self.reelId integerValue]
                            success:success
                            failure:failure];
}

@end
