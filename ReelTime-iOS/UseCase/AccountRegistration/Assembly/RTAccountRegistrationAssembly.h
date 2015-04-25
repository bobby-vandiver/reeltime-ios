#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;

@class RTApplicationAssembly;

@class RTLoginAssembly;
@class RTAccountRegistrationAutoLoginAssembly;
@class RTDeviceRegistrationAssembly;

@class RTAccountRegistrationWireframe;
@class RTAccountRegistrationViewController;
@class RTAccountRegistrationPresenter;
@class RTAccountRegistrationInteractor;
@class RTAccountRegistrationDataManager;

@interface RTAccountRegistrationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;
@property (nonatomic, strong, readonly) RTAccountRegistrationAutoLoginAssembly *accountRegistrationAutoLoginAssembly;
@property (nonatomic, strong, readonly) RTDeviceRegistrationAssembly *deviceRegistrationAssembly;

- (RTAccountRegistrationWireframe *)accountRegistrationWireframe;

- (RTAccountRegistrationViewController *)accountRegistrationViewController;

- (RTAccountRegistrationPresenter *)accountRegistrationPresenter;

- (RTAccountRegistrationInteractor *)accountRegistrationInteractor;

- (RTAccountRegistrationDataManager *)accountRegistrationDataManager;

@end
