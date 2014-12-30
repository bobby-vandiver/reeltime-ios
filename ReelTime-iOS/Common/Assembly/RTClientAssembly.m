#import "RTClientAssembly.h"

#import "RTClient.h"
#import "RTRestAPI.h"

#import "RTOAuth2Token.h"
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
    RKObjectMapping *tokenMapping = [RKObjectMapping mappingForClass:[RTOAuth2Token class]];
    [tokenMapping addAttributeMappingsFromDictionary:@{
                                                       @"access_token":     @"accessToken",
                                                       @"refresh_token":    @"refreshToken",
                                                       @"token_type":       @"tokenType",
                                                       @"expires_in":       @"expiresIn",
                                                       @"scope":            @"scope"
                                                       }];
    
    NSIndexSet *tokenSuccessfulStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    return [RKResponseDescriptor responseDescriptorWithMapping:tokenMapping
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_TOKEN_ENDPOINT
                                                       keyPath:nil
                                                   statusCodes:tokenSuccessfulStatusCodes];
    
}

@end
