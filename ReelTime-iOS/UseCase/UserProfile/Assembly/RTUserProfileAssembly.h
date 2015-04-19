#import <Typhoon/Typhoon.h>

#import "RTUserProfileViewControllerFactory.h"
#import "RTBrowseReelVideosPresenterFactory.h"

@class RTClientAssembly;
@class RTDeviceAssembly;

@class RTUserProfileViewController;

@class RTUserSummaryPresenter;
@class RTUserSummaryInteractor;
@class RTUserSummaryDataManager;

@class RTPagedListInteractor;

@class RTBrowseReelsPresenter;
@class RTBrowseReelsDataManager;
@protocol RTBrowseReelsDataManagerDelegate;

@class RTBrowseVideosPresenter;
@class RTBrowseVideosDataManager;
@protocol RTBrowseVideosView;
@protocol RTBrowseVideosDataManagerDelegate;

@interface RTUserProfileAssembly : TyphoonAssembly <RTUserProfileViewControllerFactory, RTBrowseReelVideosPresenterFactory>

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTDeviceAssembly *deviceAssembly;

- (RTUserProfileViewController *)userProfileViewControllerForUsername:(NSString *)username;

- (RTUserSummaryPresenter *)userSummaryPresenterForUsername:(NSString *)username;

- (RTUserSummaryInteractor *)userSummaryInteractorForUsername:(NSString *)username;

- (RTUserSummaryDataManager *)userSummaryDataManagerForUsername:(NSString *)username;

- (RTBrowseReelsPresenter *)browseUserReelsPresenterForUsername:(NSString *)username;

- (RTPagedListInteractor *)browseUserReelsInteractorForUsername:(NSString *)username;

- (RTBrowseReelsDataManager *)browseUserReelsDataManagerForUsername:(NSString *)username;

- (id<RTBrowseReelsDataManagerDelegate>)browseUserReelsDataManagerDelegateForUsername:(NSString *)username;

- (RTBrowseVideosPresenter *)browseReelVideosPresenterForReelId:(NSNumber *)reelId
                                                       username:(NSString *)username
                                                           view:(id<RTBrowseVideosView>)view;

- (RTPagedListInteractor *)browseReelVideosInteractorForReelId:(NSNumber *)reelId
                                                      username:(NSString *)username
                                                          view:(id<RTBrowseVideosView>)view;

- (RTBrowseVideosDataManager *)browseReelVideosDataManagerForReelId:(NSNumber *)reelId
                                                           username:(NSString *)username
                                                               view:(id<RTBrowseVideosView>)view;

- (id<RTBrowseVideosDataManagerDelegate>)browseReelVideosDataManagerDelegateForReelId:(NSNumber *)reelId
                                                                             username:(NSString *)username
                                                                                 view:(id<RTBrowseVideosView>)view;

@end
