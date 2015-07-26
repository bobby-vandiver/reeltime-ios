#import "TyphoonAssembly.h"
#import "RTBrowseUserFolloweesViewControllerFactory.h"

@class RTApplicationAssembly;
@class RTClientAssembly;
@class RTUserProfileAssembly;

@class RTBrowseUserFolloweesWireframe;
@class RTBrowseUserFolloweesViewController;
@class RTBrowseUserFolloweesDataManagerDelegate;

@class RTPagedListInteractor;

@class RTBrowseUsersPresenter;
@class RTBrowseUsersDataManager;

@interface RTBrowseUserFolloweesAssembly : TyphoonAssembly <RTBrowseUserFolloweesViewControllerFactory>

@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;
@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTUserProfileAssembly *userProfileAssembly;

- (RTBrowseUserFolloweesWireframe *)browseUserFolloweesWireframe;

- (RTBrowseUsersPresenter *)browseUserFolloweesPresenterForUsername:(NSString *)username;

- (RTPagedListInteractor *)browseUserFolloweesInteractorForUsername:(NSString *)username;

- (RTBrowseUsersDataManager *)browseUserFolloweesDataManagerForUsername:(NSString *)username;

- (RTBrowseUserFolloweesDataManagerDelegate *)browseUserFolloweesDataManagerDelegateForUsername:(NSString *)username;

@end
