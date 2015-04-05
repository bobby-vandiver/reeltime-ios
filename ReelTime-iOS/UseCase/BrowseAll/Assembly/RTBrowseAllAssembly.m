#import "RTBrowseAllAssembly.h"

#import "RTClientAssembly.h"

#import "RTBrowseAllWireframe.h"
#import "RTBrowseAllViewController.h"

#import "RTPagedListInteractor.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseUsersDataManager.h"

#import "RTBrowseReelsPresenter.h"
#import "RTBrowseReelsDataManager.h"
#import "RTBrowseReelsDataManagerDelegate.h"
#import "RTBrowseAllReelsDataManagerDelegate.h"

#import "RTBrowseVideosPresenter.h"
#import "RTBrowseVideosDataManager.h"
#import "RTBrowseVideosDataManagerDelegate.h"
#import "RTBrowseAllVideosDataManagerDelegate.h"

@implementation RTBrowseAllAssembly

- (RTBrowseAllWireframe *)browseAllWireframe {
    return [TyphoonDefinition withClass:[RTBrowseAllWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllViewController]];
        }];
    }];
}

- (RTBrowseAllViewController *)browseAllViewController {
    return [TyphoonDefinition withClass:[RTBrowseAllViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithUsersPresenter:reelsPresenter:videosPresenter:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllUsersPresenter]];
                          [method injectParameterWith:[self browseAllReelsPresenter]];
                          [method injectParameterWith:[self browseAllVideosPresenter]];
        }];
    }];
}

- (RTBrowseUsersPresenter *)browseAllUsersPresenter {
    return [TyphoonDefinition withClass:[RTBrowseUsersPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllViewController]];
                          [method injectParameterWith:[self browseAllUsersInteractor]];
                          [method injectParameterWith:[self browseAllWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseAllUsersInteractor {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllUsersPresenter]];
                          [method injectParameterWith:[self browseAllUsersDataManager]];
        }];
    }];
}

- (RTBrowseUsersDataManager *)browseAllUsersDataManager {
    return [TyphoonDefinition withClass:[RTBrowseUsersDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (RTBrowseReelsPresenter *)browseAllReelsPresenter {
    return [TyphoonDefinition withClass:[RTBrowseReelsPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllViewController]];
                          [method injectParameterWith:[self browseAllReelsInteractor]];
                          [method injectParameterWith:[self browseAllWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseAllReelsInteractor {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllReelsPresenter]];
                          [method injectParameterWith:[self browseAllReelsDataManager]];
        }];
    }];
}

- (RTBrowseReelsDataManager *)browseAllReelsDataManager {
    return [TyphoonDefinition withClass:[RTBrowseReelsDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllReelsDataManagerDelegate]];
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (id<RTBrowseReelsDataManagerDelegate>)browseAllReelsDataManagerDelegate {
    return [TyphoonDefinition withClass:[RTBrowseAllReelsDataManagerDelegate class]];
}

- (RTBrowseVideosPresenter *)browseAllVideosPresenter {
    return [TyphoonDefinition withClass:[RTBrowseVideosPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllViewController]];
                          [method injectParameterWith:[self browseAllVideosInteractor]];
                          [method injectParameterWith:[self browseAllWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseAllVideosInteractor {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllVideosPresenter]];
                          [method injectParameterWith:[self browseAllVideosDataManager]];
        }];
    }];
}

- (RTBrowseVideosDataManager *)browseAllVideosDataManager {
    return [TyphoonDefinition withClass:[RTBrowseVideosDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseAllVideosDataManagerDelegate]];
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (id<RTBrowseVideosDataManagerDelegate>)browseAllVideosDataManagerDelegate {
    return [TyphoonDefinition withClass:[RTBrowseAllVideosDataManagerDelegate class]];
}

@end
