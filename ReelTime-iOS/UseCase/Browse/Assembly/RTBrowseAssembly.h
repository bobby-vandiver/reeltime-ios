#import <Typhoon/Typhoon.h>

@class RTClientAssembly;

@class RTBrowseWireframe;
@class RTBrowseViewController;

@class RTPagedListInteractor;

@class RTBrowseUsersPresenter;
@class RTBrowseUsersDataManager;

@class RTBrowseReelsPresenter;
@class RTBrowseReelsDataManager;

@class RTBrowseVideosPresenter;
@class RTBrowseVideosDataManager;

@interface RTBrowseAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;

- (RTBrowseWireframe *)browseAllWireframe;

- (RTBrowseViewController *)browseAllViewController;

- (RTBrowseUsersPresenter *)browseAllUsersPresenter;

- (RTPagedListInteractor *)browseAllUsersInteractor;

- (RTBrowseUsersDataManager *)browseAllUsersDataManager;

- (RTBrowseReelsPresenter *)browseAllReelsPresenter;

- (RTPagedListInteractor *)browseAllReelsInteractor;

- (RTBrowseReelsDataManager *)browseAllReelsDataManager;

- (RTBrowseVideosPresenter *)browseAllVideosPresenter;

- (RTPagedListInteractor *)browseAllVideosInteractor;

- (RTBrowseVideosDataManager *)browseAllVideosDataManager;

@end
