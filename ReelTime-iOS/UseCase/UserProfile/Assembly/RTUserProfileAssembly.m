#import "RTUserProfileAssembly.h"

#import "RTClientAssembly.h"
#import "RTDeviceAssembly.h"

#import "RTAccountSettingsAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTUserProfileWireframe.h"
#import "RTUserProfileViewController.h"
#import "RTUserProfilePresenter.h"

#import "RTUserSummaryPresenter.h"
#import "RTUserSummaryInteractor.h"
#import "RTUserSummaryDataManager.h"

#import "RTPagedListInteractor.h"

#import "RTBrowseReelsPresenter.h"
#import "RTBrowseReelsDataManager.h"
#import "RTBrowseReelsDataManagerDelegate.h"
#import "RTBrowseUserReelsDataManagerDelegate.h"

#import "RTReelWireframe.h"
#import "RTNoOpReelWireframe.h"

#import "RTBrowseVideosPresenter.h"
#import "RTBrowseVideosDataManager.h"
#import "RTBrowseVideosDataManagerDelegate.h"
#import "RTBrowseReelVideosDataManagerDelegate.h"

#import "RTVideoWireframe.h"

@implementation RTUserProfileAssembly

- (RTUserProfileWireframe *)userProfileWireframeForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTUserProfileWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:accountSettingsWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self userProfileViewControllerForUsername:username]];
                          [method injectParameterWith:[self.accountSettingsAssembly accountSettingsWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTUserProfileViewController *)userProfileViewControllerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTUserProfileViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerForUsername:withUserProfilePresenter:userSummaryPresenter:reelsPresenter:reelVideosPresenterFactory:reelVideosWireframe:thumbnailSupport:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:username];
                            [initializer injectParameterWith:[self userProfilePresenterForUsername:username]];
                            [initializer injectParameterWith:[self userSummaryPresenterForUsername:username]];
                            [initializer injectParameterWith:[self browseUserReelsPresenterForUsername:username]];
                            [initializer injectParameterWith:self];
                            [initializer injectParameterWith:[self userProfileWireframeForUsername:username]];
                            [initializer injectParameterWith:[self.deviceAssembly thumbnailSupport]];
        }];
    }];
}

- (RTUserProfilePresenter *)userProfilePresenterForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTUserProfilePresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self userProfileWireframeForUsername:username]];
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
        [definition injectMethod:@selector(initWithClient:)
                      parameters:^(TyphoonMethod *method) {
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
                          [method injectParameterWith:[self browseUserReelsWireframe]];
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

- (id<RTReelWireframe>)browseUserReelsWireframe {
    return [TyphoonDefinition withClass:[RTNoOpReelWireframe class]];
}

- (RTBrowseVideosPresenter *)browseReelVideosPresenterForReelId:(NSNumber *)reelId
                                                       username:(NSString *)username
                                                           view:(id<RTBrowseVideosView>)view
                                                      wireframe:(id<RTVideoWireframe>)wireframe {
    return [TyphoonDefinition withClass:[RTBrowseVideosPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:view];
                          [method injectParameterWith:[self browseReelVideosInteractorForReelId:reelId username:username view:view wireframe:wireframe]];
                          [method injectParameterWith:wireframe];
        }];
    }];
}

- (RTPagedListInteractor *)browseReelVideosInteractorForReelId:(NSNumber *)reelId
                                                      username:(NSString *)username
                                                          view:(id<RTBrowseVideosView>)view
                                                     wireframe:(id<RTVideoWireframe>)wireframe {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseReelVideosPresenterForReelId:reelId username:username view:view wireframe:wireframe]];
                          [method injectParameterWith:[self browseReelVideosDataManagerForReelId:reelId username:username view:view wireframe:wireframe]];
        }];
    }];
}

- (RTBrowseVideosDataManager *)browseReelVideosDataManagerForReelId:(NSNumber *)reelId
                                                           username:(NSString *)username
                                                               view:(id<RTBrowseVideosView>)view
                                                          wireframe:(id<RTVideoWireframe>)wireframe {
    return [TyphoonDefinition withClass:[RTBrowseVideosDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:thumbnailSupport:client:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseReelVideosDataManagerDelegateForReelId:reelId]];
                          [method injectParameterWith:[self.deviceAssembly thumbnailSupport]];
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (id<RTBrowseVideosDataManagerDelegate>)browseReelVideosDataManagerDelegateForReelId:(NSNumber *)reelId {
    return [TyphoonDefinition withClass:[RTBrowseReelVideosDataManagerDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithReelId:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:reelId];
        }];
    }];
}

@end
