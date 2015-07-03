#import "RTBrowseAudienceMembersWireframe.h"

#import "RTBrowseAudienceMembersViewController.h"
#import "RTBrowseAudienceMembersViewControllerFactory.h"

#import "RTUserProfileWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTBrowseAudienceMembersWireframe ()

@property id<RTBrowseAudienceMembersViewControllerFactory> viewControllerFactory;
@property RTUserProfileWireframe *userProfileWireframe;

@end

@implementation RTBrowseAudienceMembersWireframe

- (instancetype)initWithViewControllerFactory:(id<RTBrowseAudienceMembersViewControllerFactory>)viewControllerFactory
                         userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewControllerFactory = viewControllerFactory;
        self.userProfileWireframe = userProfileWireframe;
    }
    return self;
}

- (void)presentAudienceMembersForReelId:(NSNumber *)reelId {
    RTBrowseAudienceMembersViewController *viewController = [self.viewControllerFactory browseAudienceMembersViewControllerForReelId:reelId];
    [self.applicationWireframe navigateToViewController:viewController];
}

- (void)presentUserForUsername:(NSString *)username {
    [self.userProfileWireframe presentUserForUsername:username];
}

@end
