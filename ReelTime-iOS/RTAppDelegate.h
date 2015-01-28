#import <UIKit/UIKit.h>

#import "RTLoginWireframe.h"
#import "RTAccountRegistrationWireframe.h"

@interface RTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property RTLoginWireframe *loginWireframe;
@property RTAccountRegistrationWireframe *accountRegistrationWireframe;

@end

