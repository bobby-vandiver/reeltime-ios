#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;
@class RTAccountRegistrationAssembly;

@class RTLoginWireframe;
@class RTLoginViewController;
@class RTLoginPresenter;
@class RTLoginInteractor;
@class RTLoginDataManager;

@interface RTLoginAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;
@property (nonatomic, strong, readonly) RTAccountRegistrationAssembly *accountRegistrationAssembly;

- (RTLoginWireframe *)loginWireframe;

- (RTLoginViewController *)loginViewController;

- (RTLoginPresenter *)loginPresenter;

- (RTLoginInteractor *)loginInteractor;

- (RTLoginDataManager *)loginDataManager;

@end
