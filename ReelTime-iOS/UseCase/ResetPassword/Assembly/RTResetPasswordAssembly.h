#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTServiceAssembly;

@class RTLoginAssembly;
@class RTApplicationAssembly;

@class RTResetPasswordWireframe;
@class RTResetPasswordViewController;
@class RTResetPasswordPresenter;
@class RTResetPasswordInteractor;
@class RTResetPasswordValidator;
@class RTResetPasswordDataManager;

@interface RTResetPasswordAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTServiceAssembly *serviceAssembly;

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTResetPasswordWireframe *)resetPasswordWireframe;

- (RTResetPasswordViewController *)resetPasswordViewController;

- (RTResetPasswordPresenter *)resetPasswordPresenter;

- (RTResetPasswordInteractor *)resetPasswordInteractor;

- (RTResetPasswordValidator *)resetPasswordValidator;

- (RTResetPasswordDataManager *)resetPasswordDataManager;

@end
