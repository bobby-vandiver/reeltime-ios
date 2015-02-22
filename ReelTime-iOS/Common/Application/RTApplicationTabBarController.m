#import "RTApplicationTabBarController.h"

@implementation RTApplicationTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBar.translucent = NO;
        self.tabBar.barTintColor = [UIColor orangeColor];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

@end
