#import "RTAccountRegistrationWireframe.h"
#import "RTAccountRegistrationViewController.h"

@interface RTAccountRegistrationWireframe ()

@property RTAccountRegistrationViewController *viewController;

@end

@implementation RTAccountRegistrationWireframe

- (instancetype)initWithViewController:(RTAccountRegistrationViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentAccountRegistrationInterfaceFromWindow:(UIWindow *)window {
    window.rootViewController = self.viewController;
}

- (void)presentLoginInterface {
    
}

- (void)presentPostAutoLoginInterface {
    
}

- (void)presentDeviceRegistrationInterface {
    
}

@end
