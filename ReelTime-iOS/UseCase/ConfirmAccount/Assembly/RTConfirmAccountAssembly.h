#import "TyphoonAssembly.h"

@class RTClientAssembly;
@class RTApplicationAssembly;

@class RTConfirmAccountWireframe;
@class RTConfirmAccountViewController;
@class RTConfirmAccountPresenter;
@class RTConfirmAccountInteractor;
@class RTConfirmAccountDataManager;

@interface RTConfirmAccountAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTConfirmAccountWireframe *)confirmAccountWireframe;

- (RTConfirmAccountViewController *)confirmAccountViewController;

- (RTConfirmAccountPresenter *)confirmAccountPresenter;

- (RTConfirmAccountInteractor *)confirmAccountInteractor;

- (RTConfirmAccountDataManager *)confirmAccountDataManager;

@end
