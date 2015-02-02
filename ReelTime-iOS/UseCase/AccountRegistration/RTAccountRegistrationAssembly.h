#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;

@class RTLoginAssembly;
@class RTAccountRegistrationAutoLoginAssembly;

@class RTAccountRegistrationWireframe;
@class RTAccountRegistrationViewController;
@class RTAccountRegistrationPresenter;
@class RTAccountRegistrationInteractor;
@class RTAccountRegistrationDataManager;

@interface RTAccountRegistrationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;
@property (nonatomic, strong, readonly) RTAccountRegistrationAutoLoginAssembly *accountRegistrationAutoLoginAssembly;

- (RTAccountRegistrationWireframe *)accountRegistrationWireframe;

- (RTAccountRegistrationViewController *)accountRegistrationViewController;

- (RTAccountRegistrationPresenter *)accountRegistrationPresenter;

- (RTAccountRegistrationInteractor *)accountRegistrationInteractor;

- (RTAccountRegistrationDataManager *)accountRegistrationDataManager;

@end