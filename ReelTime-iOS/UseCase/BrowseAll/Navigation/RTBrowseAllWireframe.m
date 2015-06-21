#import "RTBrowseAllWireframe.h"

#import "RTBrowseAllViewController.h"
#import "RTApplicationWireframe.h"

#import "RTUserProfileViewController.h"
#import "RTUserProfileViewControllerFactory.h"

#import "RTLogging.h"

@interface RTBrowseAllWireframe ()

@property RTBrowseAllViewController *viewController;
@property id<RTUserProfileViewControllerFactory> userProfileViewControllerFactory;

@end

@implementation RTBrowseAllWireframe

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe
      userProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.userProfileViewControllerFactory = userProfileViewControllerFactory;
    }
    return self;
}

- (void)presentUserForUsername:(NSString *)username {
    
    RTUserProfileViewController *userProfileViewController = [self.userProfileViewControllerFactory userProfileViewControllerForUsername:username];
    
    [self.applicationWireframe navigateToViewController:userProfileViewController];
}

- (void)presentReelForReelId:(NSNumber *)reelId
               ownerUsername:(NSString *)ownerUsername {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present Reel Details"
                                                        message:[NSString stringWithFormat:@"Reel ID: %@ & owner username: %@", reelId, ownerUsername]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)presentVideoForVideoId:(NSNumber *)videoId {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present Video Details"
                                                        message:[NSString stringWithFormat:@"Video ID: %@", videoId]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
