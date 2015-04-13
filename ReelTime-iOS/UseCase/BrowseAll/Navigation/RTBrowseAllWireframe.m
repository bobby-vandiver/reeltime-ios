#import "RTBrowseAllWireframe.h"

#import "RTBrowseAllViewController.h"
#import "RTLogging.h"

#import "RTUserProfileAssembly.h"
#import "RTUserProfileViewController.h"

@interface RTBrowseAllWireframe ()

@property RTBrowseAllViewController *viewController;

@end

@implementation RTBrowseAllWireframe

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentUserForUsername:(NSString *)username {
    
    RTUserProfileViewController *userProfileViewController = [self.userProfileAssembly userProfileViewControllerForUsername:username];
    
    [self.viewController presentViewController:userProfileViewController animated:YES completion:^{
        DDLogDebug(@"presenting user profile view controller completed");
    }];
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present User Details"
//                                                        message:[NSString stringWithFormat:@"Username: %@", username]
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];

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
