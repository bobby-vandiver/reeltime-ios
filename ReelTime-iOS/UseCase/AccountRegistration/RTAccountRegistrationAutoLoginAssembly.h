#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;
@class RTAccountRegistrationAssembly;

@class RTAccountRegistrationAutoLoginPresenter;
@class RTLoginInteractor;
@class RTLoginDataManager;

@interface RTAccountRegistrationAutoLoginAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;
@property (nonatomic, strong, readonly) RTAccountRegistrationAssembly *accountRegistrationAssembly;

- (RTAccountRegistrationAutoLoginPresenter *)accountRegistrationAutoLoginPresenter;

- (RTLoginInteractor *)accountRegistrationAutoLoginInteractor;

- (RTLoginDataManager *)accountRegistrationAutoLoginDataManager;

@end
