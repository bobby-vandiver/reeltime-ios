#import "RTNewsfeedWireframe.h"

#import "RTNewsfeedViewController.h"

@interface RTNewsfeedWireframe ()

@property RTNewsfeedViewController *viewController;

@end

@implementation RTNewsfeedWireframe

- (instancetype)initWithViewController:(RTNewsfeedViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentUserForUsername:(NSString *)username {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present User"
                                                        message:[NSString stringWithFormat:@"Username: %@", username]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];

}

- (void)presentReelForReelId:(NSNumber *)reelId
               ownerUsername:(NSString *)ownerUsername {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present Reel"
                                                        message:[NSString stringWithFormat:@"Reel ID: %@", reelId]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)presentVideoForVideoId:(NSNumber *)videoId {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present Video"
                                                        message:[NSString stringWithFormat:@"Video ID: %@", videoId]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
