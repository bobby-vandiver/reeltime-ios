#import "TyphoonAssembly.h"
#import "RTBrowseAudienceMembersViewControllerFactory.h"

@class RTApplicationAssembly;
@class RTClientAssembly;
@class RTUserProfileAssembly;

@class RTBrowseAudienceMembersWireframe;
@class RTBrowseAudienceMembersViewController;
@class RTBrowseAudienceMembersDataManagerDelegate;

@class RTPagedListInteractor;

@class RTBrowseUsersPresenter;
@class RTBrowseUsersDataManager;

@interface RTBrowseAudienceMembersAssembly : TyphoonAssembly <RTBrowseAudienceMembersViewControllerFactory>

@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;
@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTUserProfileAssembly *userProfileAssembly;

- (RTBrowseAudienceMembersWireframe *)browseAudienceMembersWireframe;

- (RTBrowseUsersPresenter *)browseAudienceMembersPresenterForReelId:(NSNumber *)reelId;

- (RTPagedListInteractor *)browseAudienceMembersInteractorForReelId:(NSNumber *)reelId;

- (RTBrowseUsersDataManager *)browseAudienceMembersDataManagerForReelId:(NSNumber *)reelId;

- (RTBrowseAudienceMembersDataManagerDelegate *)browseAudienceMembersDataManagerDelegateForReelId:(NSNumber *)reelId;

@end
