#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;

@class RTLoginWireframe;
@class RTLoginViewController;
@class RTLoginPresenter;
@class RTLoginInteractor;
@class RTLoginDataManager;

@interface RTLoginAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

- (RTLoginWireframe *)loginWireframe;

- (RTLoginViewController *)loginViewController;

- (RTLoginPresenter *)loginPresenter;

- (RTLoginInteractor *)loginInteractor;

- (RTLoginDataManager *)loginDataManager;

@end
