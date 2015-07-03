#import "RTBrowseAudienceMembersAssembly.h"

#import "RTApplicationAssembly.h"
#import "RTClientAssembly.h"
#import "RTUserProfileAssembly.h"

#import "RTBrowseAudienceMembersWireframe.h"
#import "RTBrowseAudienceMembersViewController.h"
#import "RTBrowseAudienceMembersDataManagerDelegate.h"

#import "RTPagedListInteractor.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseUsersDataManager.h"

@implementation RTBrowseAudienceMembersAssembly

- (RTBrowseAudienceMembersWireframe *)browseAudienceMembersWireframe {
    return [TyphoonDefinition withClass:[RTBrowseAudienceMembersWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewControllerFactory:userProfileWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:self];
                          [method injectParameterWith:[self.userProfileAssembly userProfileWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTBrowseAudienceMembersViewController *)browseAudienceMembersViewControllerForReelId:(NSNumber *)reelId {
    return [TyphoonDefinition withClass:[RTBrowseAudienceMembersViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithUsersPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self browseAudienceMembersPresenterForReelId:reelId]];
        }];
    }];;
}

- (RTBrowseUsersPresenter *)browseAudienceMembersPresenterForReelId:(NSNumber *)reelId {
    return [TyphoonDefinition withClass:[RTBrowseUsersPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseAudienceMembersViewControllerForReelId:reelId]];
            [method injectParameterWith:[self browseAudienceMembersInteractorForReelId:reelId]];
            [method injectParameterWith:[self browseAudienceMembersWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseAudienceMembersInteractorForReelId:(NSNumber *)reelId {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseAudienceMembersPresenterForReelId:reelId]];
            [method injectParameterWith:[self browseAudienceMembersDataManagerForReelId:reelId]];
        }];
    }];
}

- (RTBrowseUsersDataManager *)browseAudienceMembersDataManagerForReelId:(NSNumber *)reelId {
    return [TyphoonDefinition withClass:[RTBrowseUsersDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self browseAudienceMembersDataManagerDelegateForReelId:reelId]];
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (RTBrowseAudienceMembersDataManagerDelegate *)browseAudienceMembersDataManagerDelegateForReelId:(NSNumber *)reelId {
    return [TyphoonDefinition withClass:[RTBrowseAudienceMembersDataManagerDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithReelId:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:reelId];
        }];
    }];
}

@end
