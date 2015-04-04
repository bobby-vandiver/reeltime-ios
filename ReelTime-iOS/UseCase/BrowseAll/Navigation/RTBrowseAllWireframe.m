#import "RTBrowseAllWireframe.h"

#import "RTBrowseAllViewController.h"

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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present User Details"
                                                        message:[NSString stringWithFormat:@"Username: %@", username]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];

}

- (void)presentReelForReelId:(NSNumber *)reelId {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present Reel Details"
                                                        message:[NSString stringWithFormat:@"Reel ID: %@", reelId]
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
