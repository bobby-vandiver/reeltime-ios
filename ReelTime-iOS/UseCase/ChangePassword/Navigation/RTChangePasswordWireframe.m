#import "RTChangePasswordWireframe.h"
#import "RTChangePasswordViewController.h"

#import "RTApplicationWireframe.h"

@interface RTChangePasswordWireframe ()

@property RTChangePasswordViewController *viewController;

@end

@implementation RTChangePasswordWireframe

- (instancetype)initWithViewController:(RTChangePasswordViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentChangePasswordInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

@end
