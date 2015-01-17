#import <Typhoon/Typhoon.h>

#import "RTAppDelegate.h"
#import "RTLoginAssembly.h"

@interface RTApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;

- (RTAppDelegate *)appDelegate;

@end
