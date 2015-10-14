#import "RTApplicationWindowHandle.h"
#import "RTAppDelegate.h"

@implementation RTApplicationWindowHandle

- (UIWindow *)window {
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.window;
}

@end
