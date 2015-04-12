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

#import "RTBrowseVideosPresenter.h"
#import "RTBrowseVideosDataManager.h"
#import "RTBrowseVideosDataManagerDelegate.h"
#import "RTBrowseReelVideosDataManagerDelegate.h"

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

- (RTBrowseVideosPresenter *)browseReelVideosPresenterForReelId:(NSNumber *)reelId
                                                       username:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseVideosPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self userProfileViewControllerForUsername:username]];
                          [method injectParameterWith:[self browseReelVideosInteractorForReelId:reelId username:username]];
                          [method injectParameterWith:nil];
        }];
    }];
}

- (RTPagedListInteractor *)browseReelVideosInteractorForReelId:(NSNumber *)reelId
                                                      username:(NSString *)username {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseReelVideosPresenterForReelId:reelId username:username]];
                          [method injectParameterWith:[self browseReelVideosDataManagerForReelId:reelId username:username]];
        }];
    }];
}

- (RTBrowseVideosDataManager *)browseReelVideosDataManagerForReelId:(NSNumber *)reelId
                                                           username:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseVideosDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseReelVideosDataManagerDelegateForReelId:reelId username:username]];
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (id<RTBrowseVideosDataManagerDelegate>)browseReelVideosDataManagerDelegateForReelId:(NSNumber *)reelId
                                                                             username:(NSString *)username {
    return [TyphoonDefinition withClass:[RTBrowseReelVideosDataManagerDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithReelId:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:reelId];
        }];
    }];
}

@end
