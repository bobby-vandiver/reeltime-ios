#import <Typhoon/Typhoon.h>

@class RTClientAssembly;

@class RTNewsfeedWireframe;
@class RTNewsfeedViewController;
@class RTNewsfeedPresenter;
@class RTNewsfeedMessageSource;
@class RTNewsfeedInteractor;
@class RTNewsfeedDataManager;

@interface RTNewsfeedAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;

- (RTNewsfeedWireframe *)newsfeedWireframe;

- (RTNewsfeedViewController *)newsfeedViewController;

- (RTNewsfeedPresenter *)newsfeedPresenter;

- (RTNewsfeedMessageSource *)newsfeedMessageSource;

- (RTNewsfeedInteractor *)newsfeedInteractor;

- (RTNewsfeedDataManager *)newsfeedDataManager;

@end
