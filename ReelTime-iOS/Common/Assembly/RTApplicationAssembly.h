#import <Typhoon/Typhoon.h>

#import "RTAppDelegate.h"

#import "RTLoginAssembly.h"
#import "RTAccountRegistrationAssembly.h"

@interface RTApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;
@property (nonatomic, strong, readonly) RTAccountRegistrationAssembly *accountRegistrationAssembly;

- (RTAppDelegate *)appDelegate;

@end
