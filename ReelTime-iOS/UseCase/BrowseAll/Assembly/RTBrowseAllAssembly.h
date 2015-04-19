#import <Typhoon/Typhoon.h>

@class RTClientAssembly;
@class RTDeviceAssembly;
@class RTUserProfileAssembly;

@class RTBrowseAllWireframe;
@class RTBrowseAllViewController;

@class RTPagedListInteractor;

@class RTBrowseUsersPresenter;
@class RTBrowseUsersDataManager;
@protocol RTBrowseUsersDataManagerDelegate;

@class RTBrowseReelsPresenter;
@class RTBrowseReelsDataManager;
@protocol RTBrowseReelsDataManagerDelegate;

@class RTBrowseVideosPresenter;
@class RTBrowseVideosDataManager;
@protocol RTBrowseVideosDataManagerDelegate;

@interface RTBrowseAllAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTDeviceAssembly *deviceAssembly;
@property (nonatomic, strong, readonly) RTUserProfileAssembly *userProfileAssembly;

- (RTBrowseAllWireframe *)browseAllWireframe;

- (RTBrowseAllViewController *)browseAllViewController;

- (RTBrowseUsersPresenter *)browseAllUsersPresenter;

- (RTPagedListInteractor *)browseAllUsersInteractor;

- (RTBrowseUsersDataManager *)browseAllUsersDataManager;

- (id<RTBrowseUsersDataManagerDelegate>)browseAllUsersDataManagerDelegate;

- (RTBrowseReelsPresenter *)browseAllReelsPresenter;

- (RTPagedListInteractor *)browseAllReelsInteractor;

- (RTBrowseReelsDataManager *)browseAllReelsDataManager;

- (id<RTBrowseReelsDataManagerDelegate>)browseAllReelsDataManagerDelegate;

- (RTBrowseVideosPresenter *)browseAllVideosPresenter;

- (RTPagedListInteractor *)browseAllVideosInteractor;

- (RTBrowseVideosDataManager *)browseAllVideosDataManager;

- (id<RTBrowseVideosDataManagerDelegate>)browseAllVideosDataManagerDelegate;

@end
