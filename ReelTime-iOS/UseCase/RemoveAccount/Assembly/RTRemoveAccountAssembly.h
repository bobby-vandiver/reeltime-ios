#import "TyphoonAssembly.h"

@class RTClientAssembly;
@class RTApplicationAssembly;

@class RTRemoveAccountWireframe;
@class RTRemoveAccountViewController;
@class RTRemoveAccountPresenter;
@class RTRemoveAccountInteractor;
@class RTRemoveAccountDataManager;

@interface RTRemoveAccountAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTRemoveAccountWireframe *)removeAccountWireframe;

- (RTRemoveAccountViewController *)removeAccountViewController;

- (RTRemoveAccountPresenter *)removeAccountPresenter;

- (RTRemoveAccountInteractor *)removeAccountInteractor;

- (RTRemoveAccountDataManager *)removeAccountDataManager;

@end
