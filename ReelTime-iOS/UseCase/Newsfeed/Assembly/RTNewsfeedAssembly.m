#import "RTNewsfeedAssembly.h"

#import "RTClientAssembly.h"

#import "RTNewsfeedWireframe.h"
#import "RTNewsfeedViewController.h"
#import "RTNewsfeedPresenter.h"
#import "RTNewsfeedMessageSource.h"
#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedDataManager.h"

@implementation RTNewsfeedAssembly

- (RTNewsfeedWireframe *)newsfeedWireframe {
    return [TyphoonDefinition withClass:[RTNewsfeedWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self newsfeedViewController]];
        }];
    }];
}

- (RTNewsfeedViewController *)newsfeedViewController {
    return [TyphoonDefinition withClass:[RTNewsfeedViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self newsfeedPresenter]];
        }];
    }];
}

- (RTNewsfeedPresenter *)newsfeedPresenter {
    return [TyphoonDefinition withClass:[RTNewsfeedPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:messageSource:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self newsfeedViewController]];
                          [initializer injectParameterWith:[self newsfeedInteractor]];
                          [initializer injectParameterWith:[self newsfeedWireframe]];
                          [initializer injectParameterWith:[self newsfeedMessageSource]];
        }];
    }];
}

- (RTNewsfeedMessageSource *)newsfeedMessageSource {
    return [TyphoonDefinition withClass:[RTNewsfeedMessageSource class]];
}

- (RTNewsfeedInteractor *)newsfeedInteractor {
    return [TyphoonDefinition withClass:[RTNewsfeedInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self newsfeedPresenter]];
                          [initializer injectParameterWith:[self newsfeedDataManager]];
        }];
    }];
}

- (RTNewsfeedDataManager *)newsfeedDataManager {
    return [TyphoonDefinition withClass:[RTNewsfeedDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

@end
