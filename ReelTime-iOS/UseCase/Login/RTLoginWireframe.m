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
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSString *identifier = [RTLoginViewController storyboardIdentifier];
    RTLoginViewController *loginViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:identifier];

    window.rootViewController = loginViewController;
}

- (void)presentPostLoginInterface {
    
}

- (void)presentDeviceRegistrationInterface {
    
}

@end
