#import <Typhoon/Typhoon.h>

#import "RTLoginAssembly.h"
#import "RTNewsfeedAssembly.h"

#import "RTAppDelegate.h"
#import "RTApplicationWireframe.h"

@interface RTApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;
@property (nonatomic, strong, readonly) RTNewsfeedAssembly *newsfeedAssembly;

- (RTAppDelegate *)appDelegate;

- (RTApplicationWireframe *)applicationWireframe;

- (RTApplicationTabBarController *)applicationTabBarController;

@end
