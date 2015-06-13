#import "TyphoonAssembly.h"

@class RTClientAssembly;
@class RTApplicationAssembly;

@class RTChangePasswordWireframe;
@class RTChangePasswordViewController;
@class RTChangePasswordPresenter;
@class RTChangePasswordInteractor;
@class RTChangePasswordDataManager;

@interface RTChangePasswordAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTChangePasswordWireframe *)changePasswordWireframe;

- (RTChangePasswordViewController *)changePasswordViewController;

- (RTChangePasswordPresenter *)changePasswordPresenter;

- (RTChangePasswordInteractor *)changePasswordInteractor;

- (RTChangePasswordDataManager *)changePasswordDataManager;

@end
