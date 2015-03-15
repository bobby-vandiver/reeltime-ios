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

- (RTBrowseWireframe *)browseWireframe;

- (RTBrowseViewController *)browseViewController;

- (RTBrowseUsersPresenter *)browseUsersPresenter;

- (RTPagedListInteractor *)browseUsersInteractor;

- (RTBrowseUsersDataManager *)browseUsersDataManager;

- (RTBrowseReelsPresenter *)browseReelsPresenter;

- (RTPagedListInteractor *)browseReelsInteractor;

- (RTBrowseReelsDataManager *)browseReelsDataManager;

- (RTBrowseVideosPresenter *)browseVideosPresenter;

- (RTPagedListInteractor *)browseVideosInteractor;

- (RTBrowseVideosDataManager *)browseVideosDataManager;

@end
