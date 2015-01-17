#import <Typhoon/Typhoon.h>

#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTLoginWireframe.h"
#import "RTLoginViewController.h"
#import "RTLoginPresenter.h"
#import "RTLoginInteractor.h"
#import "RTLoginDataManager.h"

@interface RTLoginAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

- (RTLoginWireframe *)wireframe;

- (RTLoginViewController *)viewController;

- (RTLoginPresenter *)presenter;

- (RTLoginInteractor *)interactor;

- (RTLoginDataManager *)dataManager;

@end
