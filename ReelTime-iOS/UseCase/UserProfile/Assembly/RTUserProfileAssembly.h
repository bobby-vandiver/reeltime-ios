#import <Typhoon/Typhoon.h>

#import "RTUserProfileViewControllerFactory.h"
#import "RTBrowseReelVideosPresenterFactory.h"

@class RTClientAssembly;
@class RTDeviceAssembly;

@class RTAccountSettingsAssembly;
@class RTApplicationAssembly;

@class RTUserProfileWireframe;
@class RTUserProfileViewController;
@class RTUserProfilePresenter;

@class RTUserSummaryPresenter;
@class RTUserSummaryInteractor;
@class RTUserSummaryDataManager;

@class RTPagedListInteractor;

@class RTBrowseReelsPresenter;
@class RTBrowseReelsDataManager;
@protocol RTBrowseReelsDataManagerDelegate;

@protocol RTReelWireframe;

@class RTBrowseVideosPresenter;
@class RTBrowseVideosDataManager;
@protocol RTBrowseVideosView;
@protocol RTBrowseVideosDataManagerDelegate;

@protocol RTVideoWireframe;

@interface RTUserProfileAssembly : TyphoonAssembly <RTUserProfileViewControllerFactory, RTBrowseReelVideosPresenterFactory>

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTDeviceAssembly *deviceAssembly;

@property (nonatomic, strong, readonly) RTAccountSettingsAssembly *accountSettingsAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTUserProfileWireframe *)userProfileWireframeForUsername:(NSString *)username;

- (RTUserProfileViewController *)userProfileViewControllerForUsername:(NSString *)username;

- (RTUserProfilePresenter *)userProfilePresenterForUsername:(NSString *)username;

- (RTUserSummaryPresenter *)userSummaryPresenterForUsername:(NSString *)username;

- (RTUserSummaryInteractor *)userSummaryInteractorForUsername:(NSString *)username;

- (RTUserSummaryDataManager *)userSummaryDataManagerForUsername:(NSString *)username;

- (RTBrowseReelsPresenter *)browseUserReelsPresenterForUsername:(NSString *)username;

- (RTPagedListInteractor *)browseUserReelsInteractorForUsername:(NSString *)username;

- (RTBrowseReelsDataManager *)browseUserReelsDataManagerForUsername:(NSString *)username;

- (id<RTBrowseReelsDataManagerDelegate>)browseUserReelsDataManagerDelegateForUsername:(NSString *)username;

- (id<RTReelWireframe>)browseUserReelsWireframe;

- (RTBrowseVideosPresenter *)browseReelVideosPresenterForReelId:(NSNumber *)reelId
                                                       username:(NSString *)username
                                                           view:(id<RTBrowseVideosView>)view
                                                      wireframe:(id<RTVideoWireframe>)wireframe;

- (RTPagedListInteractor *)browseReelVideosInteractorForReelId:(NSNumber *)reelId
                                                      username:(NSString *)username
                                                          view:(id<RTBrowseVideosView>)view
                                                     wireframe:(id<RTVideoWireframe>)wireframe;

- (RTBrowseVideosDataManager *)browseReelVideosDataManagerForReelId:(NSNumber *)reelId
                                                           username:(NSString *)username
                                                               view:(id<RTBrowseVideosView>)view
                                                          wireframe:(id<RTVideoWireframe>)wireframe;

- (id<RTBrowseVideosDataManagerDelegate>)browseReelVideosDataManagerDelegateForReelId:(NSNumber *)reelId;

@end
