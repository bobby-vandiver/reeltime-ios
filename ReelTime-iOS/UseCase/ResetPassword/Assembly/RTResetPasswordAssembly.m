#import "RTResetPasswordAssembly.h"

#import "RTClientAssembly.h"
#import "RTServiceAssembly.h"

#import "RTLoginAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTResetPasswordWireframe.h"
#import "RTResetPasswordViewController.h"
#import "RTResetPasswordPresenter.h"
#import "RTResetPasswordInteractor.h"
#import "RTResetPasswordValidator.h"
#import "RTResetPasswordDataManager.h"

@implementation RTResetPasswordAssembly

- (RTResetPasswordWireframe *)resetPasswordWireframe {
    return [TyphoonDefinition withClass:[RTResetPasswordWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:loginWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self resetPasswordViewController]];
                          [method injectParameterWith:[self.loginAssembly loginWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTResetPasswordViewController *)resetPasswordViewController {
    return [TyphoonDefinition withClass:[RTResetPasswordViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self resetPasswordPresenter]];
        }];
    }];
}

- (RTResetPasswordPresenter *)resetPasswordPresenter {
    return [TyphoonDefinition withClass:[RTResetPasswordPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self resetPasswordViewController]];
            [method injectParameterWith:[self resetPasswordInteractor]];
            [method injectParameterWith:[self resetPasswordWireframe]];
        }];
    }];
}

- (RTResetPasswordInteractor *)resetPasswordInteractor {
    return [TyphoonDefinition withClass:[RTResetPasswordInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:validator:currentUserService:clientCredentialsService:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self resetPasswordPresenter]];
                          [method injectParameterWith:[self resetPasswordDataManager]];
                          [method injectParameterWith:[self resetPasswordValidator]];
                          [method injectParameterWith:[self.serviceAssembly currentUserService]];
                          [method injectParameterWith:[self.serviceAssembly clientCredentialsService]];
                      }];
    }];
}

- (RTResetPasswordValidator *)resetPasswordValidator {
    return [TyphoonDefinition withClass:[RTResetPasswordValidator class]];
}

- (RTResetPasswordDataManager *)resetPasswordDataManager {
    return [TyphoonDefinition withClass:[RTResetPasswordDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}


@end
