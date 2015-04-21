#import <Foundation/Foundation.h>

#import "RTVideoWireframe.h"

@class RTUserProfileViewController;

@interface RTUserProfileWireframe : NSObject <RTVideoWireframe>

- (instancetype)initWithViewController:(RTUserProfileViewController *)viewController;

@end
