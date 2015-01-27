#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTSecureStoreAssembly;
@class RTLoginAssembly;

@class RTAccountRegistrationWireframe;
@class RTAccountRegistrationViewController;
@class RTAccountRegistrationPresenter;
@class RTAccountRegistrationInteractor;
@class RTAccountRegistrationDataManager;

@interface RTAccountRegistrationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;
@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;

- (RTAccountRegistrationWireframe *)wireframe;

- (RTAccountRegistrationViewController *)viewController;

- (RTAccountRegistrationPresenter *)presenter;

- (RTAccountRegistrationInteractor *)interactor;

- (RTAccountRegistrationDataManager *)dataManager;

@end
