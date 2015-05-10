#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;

@class RTLoginAssembly;
@class RTApplicationAssembly;

@class RTDeviceRegistrationWireframe;
@class RTDeviceRegistrationViewController;
@class RTDeviceRegistrationPresenter;
@class RTDeviceRegistrationInteractor;
@class RTDeviceRegistrationDataManager;

@interface RTDeviceRegistrationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTDeviceRegistrationWireframe *)deviceRegistrationWireframe;

- (RTDeviceRegistrationViewController *)deviceRegistrationViewController;

- (RTDeviceRegistrationPresenter *)deviceRegistrationPresenter;

- (RTDeviceRegistrationInteractor *)deviceRegistrationInteractor;

- (RTDeviceRegistrationDataManager *)deviceRegistrationDataManager;

@end
