#import "RTBrowseWireframe.h"

#import "RTBrowseViewController.h"

@interface RTBrowseWireframe ()

@property RTBrowseViewController *viewController;

@end

@implementation RTBrowseWireframe

- (instancetype)initWithViewController:(RTBrowseViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentUserForUsername:(NSString *)username {
    
}

- (void)presentReelForReelId:(NSNumber *)reelId {
    
}

- (void)presentVideoForVideoId:(NSNumber *)videoId {
    
}

@end
