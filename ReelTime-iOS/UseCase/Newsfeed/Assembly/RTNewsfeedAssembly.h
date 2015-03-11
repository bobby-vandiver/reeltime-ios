#import <Typhoon/Typhoon.h>

@class RTClientAssembly;

@class RTNewsfeedWireframe;
@class RTNewsfeedViewController;
@class RTNewsfeedPresenter;
@class RTNewsfeedMessageSource;
@class RTPagedListInteractor;
@class RTNewsfeedDataManager;

@interface RTNewsfeedAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;

- (RTNewsfeedWireframe *)newsfeedWireframe;

- (RTNewsfeedViewController *)newsfeedViewController;

- (RTNewsfeedPresenter *)newsfeedPresenter;

- (RTNewsfeedMessageSource *)newsfeedMessageSource;

- (RTPagedListInteractor *)newsfeedInteractor;

- (RTNewsfeedDataManager *)newsfeedDataManager;

@end
