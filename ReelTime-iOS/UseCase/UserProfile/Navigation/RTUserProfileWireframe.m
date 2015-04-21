#import "RTUserProfileWireframe.h"
#import "RTUserProfileViewController.h"

@interface RTUserProfileWireframe ()

@property RTUserProfileViewController *viewController;

@end

@implementation RTUserProfileWireframe

- (instancetype)initWithViewController:(RTUserProfileViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
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
