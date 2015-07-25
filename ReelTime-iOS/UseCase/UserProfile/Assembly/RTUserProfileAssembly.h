#import <Typhoon/Typhoon.h>

#import "RTUserProfileViewControllerFactory.h"
#import "RTBrowseReelVideosPresenterFactory.h"

@class RTClientAssembly;
@class RTDeviceAssembly;
@class RTServiceAssembly;

@class RTAccountSettingsAssembly;
@class RTBrowseAudienceMembersAssembly;
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

@class RTFollowUserPresenter;
@class RTFollowUserInteractor;
@class RTFollowUserDataManager;

@class RTUnfollowUserPresenter;
@class RTUnfollowUserInteractor;
@class RTUnfollowUserDataManager;

@class RTJoinAudiencePresenter;
@class RTJoinAudienceInteractor;
@class RTJoinAudienceDataManager;

@class RTLeaveAudiencePresenter;
@class RTLeaveAudienceInteractor;
@class RTLeaveAudienceDataManager;

@interface RTUserProfileAssembly : TyphoonAssembly <RTUserProfileViewControllerFactory, RTBrowseReelVideosPresenterFactory>

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTDeviceAssembly *deviceAssembly;
@property (nonatomic, strong, readonly) RTServiceAssembly *serviceAssembly;

@property (nonatomic, strong, readonly) RTAccountSettingsAssembly *accountSettingsAssembly;
@property (nonatomic, strong, readonly) RTBrowseAudienceMembersAssembly *browseAudienceMembersAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

#pragma mark - User Profile

- (RTUserProfileWireframe *)userProfileWireframe;

- (RTUserProfileViewController *)userProfileViewControllerForUsername:(NSString *)username;

- (RTUserProfilePresenter *)userProfilePresenter;

#pragma mark - User Summary

- (RTUserSummaryPresenter *)userSummaryPresenterForUsername:(NSString *)username;

- (RTUserSummaryInteractor *)userSummaryInteractorForUsername:(NSString *)username;

- (RTUserSummaryDataManager *)userSummaryDataManagerForUsername:(NSString *)username;

#pragma mark - Browse User Reels

- (RTBrowseReelsPresenter *)browseUserReelsPresenterForUsername:(NSString *)username;

- (RTPagedListInteractor *)browseUserReelsInteractorForUsername:(NSString *)username;

- (RTBrowseReelsDataManager *)browseUserReelsDataManagerForUsername:(NSString *)username;

- (id<RTBrowseReelsDataManagerDelegate>)browseUserReelsDataManagerDelegateForUsername:(NSString *)username;

- (id<RTReelWireframe>)browseUserReelsWireframe;

#pragma mark - Browse Reel Videos

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

#pragma mark - Follow User

- (RTFollowUserPresenter *)followUserPresenterForUsername:(NSString *)username;

- (RTFollowUserInteractor *)followUserInteractorForUsername:(NSString *)username;

- (RTFollowUserDataManager *)followUserDataManager;

#pragma mark - Unfollow User

- (RTUnfollowUserPresenter *)unfollowUserPresenterForUsername:(NSString *)username;

- (RTUnfollowUserInteractor *)unfollowUserInteractorForUsername:(NSString *)username;

- (RTUnfollowUserDataManager *)unfollowUserDataManager;

#pragma mark - Join Audience

- (RTJoinAudiencePresenter *)joinAudiencePresenterForUsername:(NSString *)username;

- (RTJoinAudienceInteractor *)joinAudienceInteractorForUsername:(NSString *)username;

- (RTJoinAudienceDataManager *)joinAudienceDataManager;

#pragma mark - Leave Audience

- (RTLeaveAudiencePresenter *)leaveAudiencePresenterForUsername:(NSString *)username;

- (RTLeaveAudienceInteractor *)leaveAudienceInteractorForUsername:(NSString *)username;

- (RTLeaveAudienceDataManager *)leaveAudienceDataManager;

@end
