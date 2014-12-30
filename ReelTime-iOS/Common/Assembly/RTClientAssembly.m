#import "RTClientAssembly.h"

#import "RTClient.h"
#import "RTRestAPI.h"
#import "RTRestAPIMappingFactory.h"

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
        
        [definition injectMethod:@selector(managerWithBaseURL:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self baseUrl]];
        }];
        
        [definition injectMethod:@selector(addResponseDescriptorsFromArray:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:@[[self tokenDescriptor]]];
        }];
    }];
}

- (NSURL *)baseUrl {
    return [NSURL URLWithString: @"http://localhost:8080/reeltime"];
}

- (RKResponseDescriptor *)tokenDescriptor {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);

    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory tokenMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_TOKEN_ENDPOINT
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

@end
