#import "RTBrowseUserFollowersAssembly.h"

#import "RTApplicationAssembly.h"
#import "RTClientAssembly.h"
#import "RTUserProfileAssembly.h"

#import "RTBrowseUserFollowersWireframe.h"
#import "RTBrowseUserFollowersViewController.h"
#import "RTBrowseUserFollowersDataManagerDelegate.h"

#import "RTPagedListInteractor.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseUsersDataManager.h"

@implementation RTBrowseUserFollowersAssembly

- (RTBrowseUserFollowersWireframe *)browseUserFollowersWireframe {
    return [TyphoonDefinition withClass:[RTBrowseUserFollowersWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewControllerFactory:userProfileWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:self];
                          [method injectParameterWith:[self.userProfileAssembly userProfileWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTBrowseUserFollowersViewController *)browseUserFollowersViewControllerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUserFollowersViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithUsersPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self browseUserFollowersPresenterForUsername:username]];
        }];
    }];
}

- (RTBrowseUsersPresenter *)browseUserFollowersPresenterForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUsersPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseUserFollowersViewControllerForUsername:username]];
            [method injectParameterWith:[self browseUserFollowersInteractorForUsername:username]];
            [method injectParameterWith:[self browseUserFollowersWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseUserFollowersInteractorForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseUserFollowersPresenterForUsername:username]];
            [method injectParameterWith:[self browseUserFollowersDataManagerForUsername:username]];
        }];
    }];
}

- (RTBrowseUsersDataManager *)browseUserFollowersDataManagerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUsersDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseUserFollowersDataManagerDelegateForUsername:username]];
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (RTBrowseUserFollowersDataManagerDelegate *)browseUserFollowersDataManagerDelegateForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUserFollowersDataManagerDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithUsername:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:username];
        }];
    }];
}

@end
