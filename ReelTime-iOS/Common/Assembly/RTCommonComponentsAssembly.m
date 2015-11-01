#import "RTCommonComponentsAssembly.h"
#import "RTFilePathGenerator.h"

@implementation RTCommonComponentsAssembly

- (NSNotificationCenter *)notificationCenter {
    return [TyphoonDefinition withClass:[NSNotificationCenter class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(defaultCenter)];
    }];
}

- (NSFileManager *)fileManager {
    return [TyphoonDefinition withClass:[NSFileManager class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(defaultManager)];
    }];
}

- (RTFilePathGenerator *)filePathGenerator {
    return [TyphoonDefinition withClass:[RTFilePathGenerator class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithFileManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self fileManager]];
        }];
    }];
}

@end
