#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTLoginWireframe;

@interface RTApplicationWireframe : NSObject

- (instancetype)initWithLoginWireframe:(RTLoginWireframe *)loginWireframe;

- (void)presentInitialScreenFromWindow:(UIWindow *)window;

@end
