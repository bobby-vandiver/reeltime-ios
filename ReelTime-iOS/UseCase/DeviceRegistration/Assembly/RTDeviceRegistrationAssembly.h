#import <Typhoon/Typhoon.h>

@class RTApplicationAssembly;
@class RTLoginAssembly;

@class RTDeviceRegistrationWireframe;
@class RTDeviceRegistrationViewController;

@interface RTDeviceRegistrationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;
@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;

- (RTDeviceRegistrationWireframe *)deviceRegistrationWireframe;

- (RTDeviceRegistrationViewController *)deviceRegistrationViewController;

@end
