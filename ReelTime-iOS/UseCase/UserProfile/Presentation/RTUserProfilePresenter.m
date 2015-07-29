#import "RTUserProfilePresenter.h"
#import "RTUserProfileWireframe.h"

@interface RTUserProfilePresenter ()

@property RTUserProfileWireframe *wireframe;

@end

@implementation RTUserProfilePresenter

- (instancetype)initWithWireframe:(RTUserProfileWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
    }
    return self;
}

- (void)requestedAccountSettings {
    [self.wireframe presentAccountSettingsInterface];
}

- (void)requestedAudienceMembersForReelId:(NSNumber *)reelId {
    [self.wireframe presentAudienceMembersForReelId:reelId];
}

- (void)requestedFollowersForUsername:(NSString *)username {
    [self.wireframe presentFollowersForUsername:username];
}

- (void)requestedFolloweesForUsername:(NSString *)username {
    [self.wireframe presentFolloweesForUsername:username];
}

@end
