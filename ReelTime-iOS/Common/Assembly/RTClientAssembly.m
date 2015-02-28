#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTClient.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"
#import "RTClientAdditionalConfiguration.h"
#import "RTAuthenticationAwareHTTPClient.h"

#import "RTEndpointPathFormatter.h"

#import "RTResponseDescriptorFactory.h"
#import "RTServerErrorsConverter.h"

#import <RestKit/RestKit.h>

@implementation RTClientAssembly

- (RTClient *)reelTimeClient {
    return [TyphoonDefinition withClass:[RTClient class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithHttpClient:pathFormatter:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self authenticationAwareHTTPClient]];
                            [initializer injectParameterWith:[self endpointPathFormatter]];
        }];
    }];
}

- (RTEndpointPathFormatter *)endpointPathFormatter {
    return [TyphoonDefinition withClass:[RTEndpointPathFormatter class]];
}

- (RTAuthenticationAwareHTTPClient *)authenticationAwareHTTPClient {
    return [TyphoonDefinition withClass:[RTAuthenticationAwareHTTPClient class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithDelegate:restKitObjectManager:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self authenticationAwareHTTPClientDelegate]];
                            [initializer injectParameterWith:[self restKitObjectManager]];
                        }];
    }];
}

- (RTAuthenticationAwareHTTPClientDelegate *)authenticationAwareHTTPClientDelegate {
    return [TyphoonDefinition withClass:[RTAuthenticationAwareHTTPClientDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithCurrentUserStore:tokenStore:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self.secureStoreAssembly currentUserStore]];
                            [initializer injectParameterWith:[self.secureStoreAssembly tokenStore]];
                        }];
    }];
}

- (RKObjectManager *)restKitObjectManager {
    return [TyphoonDefinition withClass:[RKObjectManager class] configuration:^(TyphoonDefinition *definition) {
        [RTClientAdditionalConfiguration registerEmptyResponseSupport];
        
        [definition useInitializer:@selector(managerWithBaseURL:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self baseUrl]];
        }];
        
        [definition injectMethod:@selector(addResponseDescriptorsFromArray:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:@[
                                          [RTResponseDescriptorFactory tokenDescriptor],
                                          [RTResponseDescriptorFactory tokenErrorDescriptor],
                                          [RTResponseDescriptorFactory accountRegistrationDescriptor],
                                          [RTResponseDescriptorFactory accountRegistrationErrorDescriptor],
                                          [RTResponseDescriptorFactory clientRegistrationDescriptor],
                                          [RTResponseDescriptorFactory clientRegistrationErrorDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationErrorDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationSendEmailDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationSendEmailErrorDescriptor],
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
