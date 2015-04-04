#import <Typhoon/Typhoon.h>

@class RTClientAssembly;

@class RTBrowseAllWireframe;
@class RTBrowseAllViewController;

@class RTPagedListInteractor;

@class RTBrowseUsersPresenter;
@class RTBrowseUsersDataManager;

@class RTBrowseReelsPresenter;
@class RTBrowseReelsDataManager;

@class RTBrowseVideosPresenter;
@class RTBrowseVideosDataManager;

@interface RTBrowseAllAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;

- (RTBrowseAllWireframe *)browseAllWireframe;

- (RTBrowseAllViewController *)browseAllViewController;

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
