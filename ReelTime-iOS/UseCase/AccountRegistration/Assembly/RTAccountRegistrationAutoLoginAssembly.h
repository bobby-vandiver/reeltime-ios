#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;
@class RTCommonComponentsAssembly;
@class RTAccountRegistrationAssembly;

@class RTLoginInteractor;
@class RTLoginDataManager;

@interface RTAccountRegistrationAutoLoginAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;
@property (nonatomic, strong, readonly) RTCommonComponentsAssembly *commonComponentsAssembly;
@property (nonatomic, strong, readonly) RTAccountRegistrationAssembly *accountRegistrationAssembly;

- (RTLoginInteractor *)accountRegistrationAutoLoginInteractor;

- (RTLoginDataManager *)accountRegistrationAutoLoginDataManager;

@end
