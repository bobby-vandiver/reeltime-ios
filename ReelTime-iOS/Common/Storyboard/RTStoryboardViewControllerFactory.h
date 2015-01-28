#import <Foundation/Foundation.h>

@class RTLoginViewController;
@class RTAccountRegistrationViewController;

@interface RTStoryboardViewControllerFactory : NSObject

+ (id)viewControllerWithStoryboardIdentifier:(NSString *)identifier;

@end
