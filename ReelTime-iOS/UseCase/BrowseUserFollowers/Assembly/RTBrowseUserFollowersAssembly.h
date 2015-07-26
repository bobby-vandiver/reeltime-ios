#import "TyphoonAssembly.h"
#import "RTBrowseUserFollowersViewControllerFactory.h"

@class RTApplicationAssembly;
@class RTClientAssembly;
@class RTUserProfileAssembly;

@class RTBrowseUserFollowersWireframe;
@class RTBrowseUserFollowersViewController;
@class RTBrowseUserFollowersDataManagerDelegate;

@class RTPagedListInteractor;

@class RTBrowseUsersPresenter;
@class RTBrowseUsersDataManager;

@interface RTBrowseUserFollowersAssembly : TyphoonAssembly <RTBrowseUserFollowersViewControllerFactory>

@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;
@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTUserProfileAssembly *userProfileAssembly;

- (RTBrowseUserFollowersWireframe *)browseUserFollowersWireframe;

- (RTBrowseUsersPresenter *)browseUserFollowersPresenterForUsername:(NSString *)username;

- (RTPagedListInteractor *)browseUserFollowersInteractorForUsername:(NSString *)username;

- (RTBrowseUsersDataManager *)browseUserFollowersDataManagerForUsername:(NSString *)username;

- (RTBrowseUserFollowersDataManagerDelegate *)browseUserFollowersDataManagerDelegateForUsername:(NSString *)username;

@end
