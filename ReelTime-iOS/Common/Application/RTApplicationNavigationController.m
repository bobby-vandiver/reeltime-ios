#import "RTApplicationNavigationController.h"

static const NSInteger EffectiveRootViewControllerIndex = 1;

@interface RTApplicationNavigationController ()

@property UIViewController *fakeRootViewController;

@end

@implementation RTApplicationNavigationController

- (instancetype)initWithoutRootViewController {
    UIViewController *fakeRootViewController = [[UIViewController alloc] init];
    self = [super initWithRootViewController:fakeRootViewController];
    if (self) {
        self.fakeRootViewController = fakeRootViewController;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [self initWithoutRootViewController];
    if (self) {
        self.rootViewController = rootViewController;
    }
    return self;
}

- (NSArray *)viewControllers {
    NSArray *viewControllers = [super viewControllers];
    return [self removeFakeRootControllerFromViewControllers:viewControllers];
}

- (NSArray *)removeFakeRootControllerFromViewControllers:(NSArray *)viewControllers {

    if (viewControllers != nil && viewControllers.count > 0) {
        NSMutableArray *mutableViewControllers = [viewControllers mutableCopy];

        [mutableViewControllers removeObjectAtIndex:0];
        return mutableViewControllers;
    }
    
    return viewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self popToViewController:self.fakeRootViewController animated:animated];
}

- (UIViewController *)rootViewController {
    NSArray *viewControllers = [super viewControllers];
    
    if (viewControllers != nil && viewControllers.count > EffectiveRootViewControllerIndex) {
        return viewControllers[EffectiveRootViewControllerIndex];
    }
    
    return nil;
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    [self popToRootViewControllerAnimated:NO];
    
    rootViewController.navigationItem.hidesBackButton = YES;
    [self pushViewController:rootViewController animated:NO];
}

@end
