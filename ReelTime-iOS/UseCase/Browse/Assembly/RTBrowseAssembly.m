#import "RTBrowseAssembly.h"

#import "RTClientAssembly.h"

#import "RTBrowseWireframe.h"
#import "RTBrowseViewController.h"

#import "RTPagedListInteractor.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseUsersDataManager.h"

#import "RTBrowseReelsPresenter.h"
#import "RTBrowseReelsDataManager.h"

#import "RTBrowseVideosPresenter.h"
#import "RTBrowseVideosDataManager.h"

@implementation RTBrowseAssembly

- (RTBrowseWireframe *)browseWireframe {
    return [TyphoonDefinition withClass:[RTBrowseWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseViewController]];
        }];
    }];
}

- (RTBrowseViewController *)browseViewController {
    return [TyphoonDefinition withClass:[RTBrowseViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(viewControllerWithUsersPresenter:reelsPresenter:videosPresenter:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseUsersPresenter]];
                          [method injectParameterWith:[self browseReelsPresenter]];
                          [method injectParameterWith:[self browseVideosPresenter]];
        }];
    }];
}

- (RTBrowseUsersPresenter *)browseUsersPresenter {
    return [TyphoonDefinition withClass:[RTBrowseUsersPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseViewController]];
                          [method injectParameterWith:[self browseUsersInteractor]];
                          [method injectParameterWith:[self browseWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseUsersInteractor {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseUsersPresenter]];
                          [method injectParameterWith:[self browseUsersDataManager]];
        }];
    }];
}

- (RTBrowseUsersDataManager *)browseUsersDataManager {
    return [TyphoonDefinition withClass:[RTBrowseUsersDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (RTBrowseReelsPresenter *)browseReelsPresenter {
    return [TyphoonDefinition withClass:[RTBrowseReelsPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseViewController]];
                          [method injectParameterWith:[self browseReelsInteractor]];
                          [method injectParameterWith:[self browseWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseReelsInteractor {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseReelsPresenter]];
                          [method injectParameterWith:[self browseReelsDataManager]];
        }];
    }];
}

- (RTBrowseReelsDataManager *)browseReelsDataManager {
    return [TyphoonDefinition withClass:[RTBrowseReelsDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (RTBrowseVideosPresenter *)browseVideosPresenter {
    return [TyphoonDefinition withClass:[RTBrowseVideosPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseViewController]];
                          [method injectParameterWith:[self browseVideosInteractor]];
                          [method injectParameterWith:[self browseWireframe]];
        }];
    }];
}

- (RTPagedListInteractor *)browseVideosInteractor {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self browseVideosPresenter]];
                          [method injectParameterWith:[self browseVideosDataManager]];
        }];
    }];
}

- (RTBrowseVideosDataManager *)browseVideosDataManager {
    return [TyphoonDefinition withClass:[RTBrowseVideosDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

@end
