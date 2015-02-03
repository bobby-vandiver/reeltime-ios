#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTClient.h"
#import "RTClientDelegate.h"

#import "RTResponseDescriptorFactory.h"
#import "RTServerErrorsConverter.h"

#import <RestKit/RestKit.h>

@implementation RTClientAssembly

- (RTClient *)reelTimeClient {
    return [TyphoonDefinition withClass:[RTClient class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithDelegate:RestKitObjectManager:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self reelTimeClientDelegate]];
                            [initializer injectParameterWith:[self restKitObjectManager]];
        }];
    }];
}

- (RTClientDelegate *)reelTimeClientDelegate {
    return [TyphoonDefinition withClass:[RTClientDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithCurrentUserStore:tokenStore:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self.secureStoreAssembly currentUserStore]];
                            [initializer injectParameterWith:[self.secureStoreAssembly tokenStore]];
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
                                          [RTResponseDescriptorFactory accountRegistrationErrorDescriptor],
                                          [RTResponseDescriptorFactory newsfeedDescriptor]
                                          ]];
        }];
    }];
}

- (NSURL *)baseUrl {
    return [NSURL URLWithString: @"http://localhost:8080/reeltime"];
}

- (RTServerErrorsConverter *)serverErrorsConverter {
    return [TyphoonDefinition withClass:[RTServerErrorsConverter class]];
}

@end
