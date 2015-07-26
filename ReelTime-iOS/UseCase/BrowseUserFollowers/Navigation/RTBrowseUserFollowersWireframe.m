#import "RTBrowseUserFollowersWireframe.h"

#import "RTBrowseUserFollowersViewController.h"
#import "RTBrowseUserFollowersViewControllerFactory.h"

#import "RTUserProfileWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTBrowseUserFollowersWireframe ()

@property id<RTBrowseUserFollowersViewControllerFactory> viewControllerFactory;
@property RTUserProfileWireframe *userProfileWireframe;

@end

@implementation RTBrowseUserFollowersWireframe

- (instancetype)initWithViewControllerFactory:(id<RTBrowseUserFollowersViewControllerFactory>)viewControllerFactory
                         userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewControllerFactory = viewControllerFactory;
        self.userProfileWireframe = userProfileWireframe;
    }
    return self;
}

- (void)presentFollowersForUsername:(NSString *)username {
    RTBrowseUserFollowersViewController *viewController = [self.viewControllerFactory browseUserFollowersViewControllerForUsername:username];
    [self.applicationWireframe navigateToViewController:viewController];
}

- (void)presentUserForUsername:(NSString *)username {
    [self.userProfileWireframe presentUserForUsername:username];
}

@end
