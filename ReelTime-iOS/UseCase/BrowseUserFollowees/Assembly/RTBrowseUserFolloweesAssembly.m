#import "RTBrowseUserFolloweesAssembly.h"

#import "RTApplicationAssembly.h"
#import "RTClientAssembly.h"
#import "RTUserProfileAssembly.h"

#import "RTBrowseUserFolloweesWireframe.h"
#import "RTBrowseUserFolloweesViewController.h"
#import "RTBrowseUserFolloweesDataManagerDelegate.h"

#import "RTPagedListInteractor.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseUsersDataManager.h"

@implementation RTBrowseUserFolloweesAssembly

- (RTBrowseUserFolloweesWireframe *)browseUserFolloweesWireframe {
    return [TyphoonDefinition withClass:[RTBrowseUserFolloweesWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewControllerFactory:userProfileWireframe:applicationWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:self];
            [method injectParameterWith:[self.userProfileAssembly userProfileWireframe]];
            [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTBrowseUserFolloweesViewController *)browseUserFolloweesViewControllerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUserFolloweesViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithUsersPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self browseUserFolloweesPresenterForUsername:username]];
        }];
    }];
}

- (RTBrowseUsersPresenter *)browseUserFolloweesPresenterForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUsersPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseUserFolloweesViewControllerForUsername:username]];
            [method injectParameterWith:[self browseUserFolloweesInteractorForUsername:username]];
            [method injectParameterWith:[self browseUserFolloweesWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseUserFolloweesInteractorForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseUserFolloweesPresenterForUsername:username]];
            [method injectParameterWith:[self browseUserFolloweesDataManagerForUsername:username]];
        }];
    }];
}

- (RTBrowseUsersDataManager *)browseUserFolloweesDataManagerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUsersDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseUserFolloweesDataManagerDelegateForUsername:username]];
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (RTBrowseUserFolloweesDataManagerDelegate *)browseUserFolloweesDataManagerDelegateForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUserFolloweesDataManagerDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithUsername:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:username];
        }];
    }];
}

@end
