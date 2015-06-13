#import "RTChangeDisplayNameWireframe.h"
#import "RTChangeDisplayNameViewController.h"

#import "RTApplicationWireframe.h"

@interface RTChangeDisplayNameWireframe ()

@property RTChangeDisplayNameViewController *viewController;

@end

@implementation RTChangeDisplayNameWireframe

- (instancetype)initWithViewController:(RTChangeDisplayNameViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentChangeDisplayNameInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

@end
