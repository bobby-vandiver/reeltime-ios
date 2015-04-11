#import "RTUserProfileAssembly.h"

#import "RTClientAssembly.h"

#import "RTUserProfileViewController.h"

#import "RTUserSummaryPresenter.h"
#import "RTUserSummaryInteractor.h"
#import "RTUserSummaryDataManager.h"

#import "RTPagedListInteractor.h"

#import "RTBrowseReelsPresenter.h"
#import "RTBrowseReelsDataManager.h"
#import "RTBrowseReelsDataManagerDelegate.h"
#import "RTBrowseUserReelsDataManagerDelegate.h"

@implementation RTUserProfileAssembly

- (RTUserProfileViewController *)userProfileViewControllerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTUserProfileViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerForUsername:withUserPresenter:reelsPresenter:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:username];
                            [initializer injectParameterWith:[self userSummaryPresenterForUsername:username]];
                            [initializer injectParameterWith:[self browseUserReelsPresenterForUsername:username]];
        }];
    }];
}

- (RTUserSummaryPresenter *)userSummaryPresenterForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTUserSummaryPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self userProfileViewControllerForUsername:username]];
                          [method injectParameterWith:[self userSummaryInteractorForUsername:username]];
        }];
    }];
}

- (RTUserSummaryInteractor *)userSummaryInteractorForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTUserSummaryInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self userSummaryPresenterForUsername:username]];
                          [method injectParameterWith:[self userSummaryDataManagerForUsername:username]];
        }];
    }];
}

- (RTUserSummaryDataManager *)userSummaryDataManagerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTUserSummaryDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self userSummaryInteractorForUsername:username]];
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (RTBrowseReelsPresenter *)browseUserReelsPresenterForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseReelsPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self userProfileViewControllerForUsername:username]];
                          [method injectParameterWith:[self browseUserReelsInteractorForUsername:username]];

                          // TODO: Inject wireframe
                          [method injectParameterWith:nil];
        }];
    }];
}

- (RTPagedListInteractor *)browseUserReelsInteractorForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseUserReelsPresenterForUsername:username]];
                          [method injectParameterWith:[self browseUserReelsDataManagerForUsername:username]];
        }];
    }];
}

- (RTBrowseReelsDataManager *)browseUserReelsDataManagerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseReelsDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseUserReelsDataManagerDelegateForUsername:username]];
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (id<RTBrowseReelsDataManagerDelegate>)browseUserReelsDataManagerDelegateForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseUserReelsDataManagerDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithUsername:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:username];
        }];
    }];
}

@end
