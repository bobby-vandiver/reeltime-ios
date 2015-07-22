#import "RTUserProfileAssembly.h"

#import "RTClientAssembly.h"
#import "RTDeviceAssembly.h"
#import "RTServiceAssembly.h"

#import "RTAccountSettingsAssembly.h"
#import "RTBrowseAudienceMembersAssembly.h"
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

#import "RTJoinAudiencePresenter.h"
#import "RTJoinAudienceInteractor.h"
#import "RTJoinAudienceDataManager.h"

#import "RTLeaveAudiencePresenter.h"
#import "RTLeaveAudienceInteractor.h"
#import "RTLeaveAudienceDataManager.h"

@implementation RTUserProfileAssembly

#pragma mark - User Profile

- (RTUserProfileWireframe *)userProfileWireframe {
    return [TyphoonDefinition withClass:[RTUserProfileWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithUserProfileViewControllerFactory:accountSettingsWireframe:browseAudienceMembersWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:self];
                          [method injectParameterWith:[self.accountSettingsAssembly accountSettingsWireframe]];
                          [method injectParameterWith:[self.browseAudienceMembersAssembly browseAudienceMembersWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTUserProfileViewController *)userProfileViewControllerForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTUserProfileViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerForUsername:withUserProfilePresenter:userSummaryPresenter:reelsPresenter:joinAudiencePresenter:leaveAudiencePresenter:reelVideosPresenterFactory:reelVideosWireframe:thumbnailSupport:currentUserService:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:username];
                            [initializer injectParameterWith:[self userProfilePresenter]];
                            [initializer injectParameterWith:[self userSummaryPresenterForUsername:username]];
                            [initializer injectParameterWith:[self browseUserReelsPresenterForUsername:username]];
                            [initializer injectParameterWith:[self joinAudiencePresenterForUsername:username]];
                            [initializer injectParameterWith:[self leaveAudiencePresenterForUsername:username]];
                            [initializer injectParameterWith:self];
                            [initializer injectParameterWith:[self userProfileWireframe]];
                            [initializer injectParameterWith:[self.deviceAssembly thumbnailSupport]];
                            [initializer injectParameterWith:[self.serviceAssembly currentUserService]];
        }];
    }];
}

- (RTUserProfilePresenter *)userProfilePresenter {
    return [TyphoonDefinition withClass:[RTUserProfilePresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self userProfileWireframe]];
        }];
    }];
}

#pragma mark - User Summary

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

#pragma mark - Browse User Reels

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

#pragma mark - Browse Reel Videos

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

#pragma mark - Join Audience

- (RTJoinAudiencePresenter *)joinAudiencePresenterForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTJoinAudiencePresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self userProfileViewControllerForUsername:username]];
            [method injectParameterWith:[self joinAudienceInteractorForUsername:username]];
        }];
    }];
}

- (RTJoinAudienceInteractor *)joinAudienceInteractorForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTJoinAudienceInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self joinAudiencePresenterForUsername:username]];
            [method injectParameterWith:[self joinAudienceDataManager]];
        }];
    }];
}

- (RTJoinAudienceDataManager *)joinAudienceDataManager {
    return [TyphoonDefinition withClass:[RTJoinAudienceDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

#pragma mark - Leave Audience

- (RTLeaveAudiencePresenter *)leaveAudiencePresenterForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTLeaveAudiencePresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self userProfileViewControllerForUsername:username]];
            [method injectParameterWith:[self leaveAudienceInteractorForUsername:username]];
        }];
    }];
}

- (RTLeaveAudienceInteractor *)leaveAudienceInteractorForUsername:(NSString *)username {
    return [TyphoonDefinition withClass:[RTLeaveAudienceInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self leaveAudiencePresenterForUsername:username]];
            [method injectParameterWith:[self leaveAudienceDataManager]];
        }];
    }];
}

- (RTLeaveAudienceDataManager *)leaveAudienceDataManager {
    return [TyphoonDefinition withClass:[RTLeaveAudienceDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}


@end
