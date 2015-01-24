#import "RTClientAssembly.h"

#import "RTClient.h"
#import "RTResponseDescriptorFactory.h"

#import <RestKit/RestKit.h>

@implementation RTClientAssembly

- (RTClient *)reelTimeClient {
    return [TyphoonDefinition withClass:[RTClient class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithRestKitObjectManager:)
                        parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self restKitObjectManager]];
        }];
    }];
}

- (RKObjectManager *)restKitObjectManager {
    return [TyphoonDefinition withClass:[RKObjectManager class] configuration:^(TyphoonDefinition *definition) {
        
        [definition useInitializer:@selector(managerWithBaseURL:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self baseUrl]];
        }];
        
        [definition injectMethod:@selector(addResponseDescriptorsFromArray:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:@[
                                          [RTResponseDescriptorFactory tokenDescriptor],
                                          [RTResponseDescriptorFactory tokenErrorDescriptor],
                                          [RTResponseDescriptorFactory accountRegistrationDescriptor],
                                          [RTResponseDescriptorFactory accountRegistrationErrorDescriptor]
                                          ]];
        }];
    }];
}

- (NSURL *)baseUrl {
    return [NSURL URLWithString: @"http://localhost:8080/reeltime"];
}


@end
