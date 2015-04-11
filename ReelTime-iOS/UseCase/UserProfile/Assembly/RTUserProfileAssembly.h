#import <Typhoon/Typhoon.h>

@class RTClientAssembly;

@class RTUserProfileViewController;

@class RTUserSummaryPresenter;
@class RTUserSummaryInteractor;
@class RTUserSummaryDataManager;

@class RTPagedListInteractor;

@class RTBrowseReelsPresenter;
@class RTBrowseReelsDataManager;
@protocol RTBrowseReelsDataManagerDelegate;

@interface RTUserProfileAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;

- (RTUserProfileViewController *)userProfileViewControllerForUsername:(NSString *)username;

- (RTUserSummaryPresenter *)userSummaryPresenterForUsername:(NSString *)username;

- (RTUserSummaryInteractor *)userSummaryInteractorForUsername:(NSString *)username;

- (RTUserSummaryDataManager *)userSummaryDataManagerForUsername:(NSString *)username;

- (RTBrowseReelsPresenter *)browseUserReelsPresenterForUsername:(NSString *)username;

- (RTPagedListInteractor *)browseUserReelsInteractorForUsername:(NSString *)username;

- (RTBrowseReelsDataManager *)browseUserReelsDataManagerForUsername:(NSString *)username;

- (id<RTBrowseReelsDataManagerDelegate>)browseUserReelsDataManagerDelegateForUsername:(NSString *)username;

@end
