#import "RTRemoveAccountWireframe.h"

#import "RTRemoveAccountViewController.h"
#import "RTApplicationWireframe.h"

@interface RTRemoveAccountWireframe ()

@property RTRemoveAccountViewController *viewController;

@end

@implementation RTRemoveAccountWireframe

- (instancetype)initWithViewController:(RTRemoveAccountViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentRemoveAccountInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

- (void)presentPostRemoveAccountInterface {
    [self.applicationWireframe presentInitialScreen];
}

@end
