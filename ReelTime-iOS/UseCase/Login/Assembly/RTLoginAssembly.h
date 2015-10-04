#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;

@class RTCommonComponentsAssembly;

@class RTAccountRegistrationAssembly;
@class RTDeviceRegistrationAssembly;

@class RTResetPasswordAssembly;
@class RTApplicationAssembly;

@class RTLoginWireframe;
@class RTLoginViewController;
@class RTLoginPresenter;
@class RTLoginInteractor;
@class RTLoginDataManager;

@interface RTLoginAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

@property (nonatomic, strong, readonly) RTCommonComponentsAssembly *commonComponentsAssembly;

@property (nonatomic, strong, readonly) RTAccountRegistrationAssembly *accountRegistrationAssembly;
@property (nonatomic, strong, readonly) RTDeviceRegistrationAssembly *deviceRegistrationAssembly;

@property (nonatomic, strong, readonly) RTResetPasswordAssembly *resetPasswordAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTLoginWireframe *)loginWireframe;

- (RTLoginViewController *)loginViewController;

- (RTLoginPresenter *)loginPresenter;

- (RTLoginInteractor *)loginInteractor;

- (RTLoginDataManager *)loginDataManager;

@end
