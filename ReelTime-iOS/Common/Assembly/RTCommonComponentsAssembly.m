#import "RTCommonComponentsAssembly.h"

@implementation RTCommonComponentsAssembly

- (NSNotificationCenter *)notificationCenter {
    return [TyphoonDefinition withClass:[NSNotificationCenter class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(defaultCenter)];
    }];
}

@end
