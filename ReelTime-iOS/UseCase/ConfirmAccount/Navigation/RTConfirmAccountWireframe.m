#import "RTConfirmAccountWireframe.h"
#import "RTConfirmAccountViewController.h"

#import "RTApplicationWireframe.h"

@interface RTConfirmAccountWireframe ()

@property RTConfirmAccountViewController *viewController;

@end

@implementation RTConfirmAccountWireframe

- (instancetype)initWithViewController:(RTConfirmAccountViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentConfirmAccountInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

@end
