#import "RTBrowseUserFolloweesWireframe.h"

#import "RTBrowseUserFolloweesViewController.h"
#import "RTBrowseUserFolloweesViewControllerFactory.h"

#import "RTUserProfileWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTBrowseUserFolloweesWireframe ()

@property id<RTBrowseUserFolloweesViewControllerFactory> viewControllerFactory;
@property RTUserProfileWireframe *userProfileWireframe;

@end

@implementation RTBrowseUserFolloweesWireframe

- (instancetype)initWithViewControllerFactory:(id<RTBrowseUserFolloweesViewControllerFactory>)viewControllerFactory
                         userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewControllerFactory = viewControllerFactory;
        self.userProfileWireframe = userProfileWireframe;
    }
    return self;
}

- (void)presentFolloweesForUsername:(NSString *)username {
    RTBrowseUserFolloweesViewController *viewController = [self.viewControllerFactory browseUserFolloweesViewControllerForUsername:username];
    [self.applicationWireframe navigateToViewController:viewController];
}

- (void)presentUserForUsername:(NSString *)username {
    [self.userProfileWireframe presentUserForUsername:username];
}

@end
