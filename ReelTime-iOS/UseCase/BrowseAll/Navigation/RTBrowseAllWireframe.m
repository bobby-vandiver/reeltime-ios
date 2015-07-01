#import "RTBrowseAllWireframe.h"
#import "RTBrowseAllViewController.h"

#import "RTUserProfileWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTUserProfileViewController.h"
#import "RTLogging.h"

@interface RTBrowseAllWireframe ()

@property RTBrowseAllViewController *viewController;
@property RTUserProfileWireframe *userProfileWireframe;

@end

@implementation RTBrowseAllWireframe

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController
                  userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.userProfileWireframe = userProfileWireframe;
    }
    return self;
}

- (void)presentUserForUsername:(NSString *)username {
    [self.userProfileWireframe presentUserForUsername:username];
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
