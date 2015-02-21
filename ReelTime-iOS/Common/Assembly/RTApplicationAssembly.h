#import <Typhoon/Typhoon.h>

#import "RTLoginAssembly.h"

#import "RTAppDelegate.h"
#import "RTApplicationWireframe.h"

@interface RTApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;

- (RTAppDelegate *)appDelegate;

- (RTApplicationWireframe *)applicationWireframe;

@end
