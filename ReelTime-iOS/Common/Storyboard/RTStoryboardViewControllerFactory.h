#import <Foundation/Foundation.h>

@class RTLoginViewController;
@class RTAccountRegistrationViewController;

@interface RTStoryboardViewControllerFactory : NSObject

+ (RTLoginViewController *)loginViewController;

+ (RTAccountRegistrationViewController *)accountRegistrationViewController;

@end
