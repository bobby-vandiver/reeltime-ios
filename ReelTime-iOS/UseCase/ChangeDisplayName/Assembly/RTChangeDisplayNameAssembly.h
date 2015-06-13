#import "TyphoonAssembly.h"

@class RTClientAssembly;
@class RTApplicationAssembly;

@class RTChangeDisplayNameWireframe;
@class RTChangeDisplayNameViewController;
@class RTChangeDisplayNamePresenter;
@class RTChangeDisplayNameInteractor;
@class RTChangeDisplayNameDataManager;

@interface RTChangeDisplayNameAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTChangeDisplayNameWireframe *)changeDisplayNameWireframe;

- (RTChangeDisplayNameViewController *)changeDisplayNameViewController;

- (RTChangeDisplayNamePresenter *)changeDisplayNamePresenter;

- (RTChangeDisplayNameInteractor *)changeDisplayNameInteractor;

- (RTChangeDisplayNameDataManager *)changeDisplayNameDataManager;

@end
