#import "RTLoginWireframe.h"
#import "RTLoginPresenter.h"
#import "RTLoginViewController.h"

@interface RTLoginWireframe ()

@property RTLoginPresenter *presenter;
@property RTLoginViewController *viewController;

@end

@implementation RTLoginWireframe

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                   viewController:(RTLoginViewController *)viewController {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.viewController = viewController;
    }
    return self;
}

- (void)presentLoginInterfaceFromWindow:(UIWindow *)window {
}

- (void)presentPostLoginInterface {
    
}

- (void)presentDeviceRegistrationInterface {
    
}

@end
