//
//  ReelTimeClientAssembly.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "ReelTimeClientAssembly.h"
#import "ReelTimeClient.h"

#import "OAuth2Token.h"

#import <RestKit/RestKit.h>

@implementation ReelTimeClientAssembly

- (ReelTimeClient *)reelTimeClient {
    return [TyphoonDefinition withClass:[ReelTimeClient class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithRestKitObjectManager:)
                        parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self restKitObjectManager]];
        }];
    }];
}

- (NSURL *)baseUrl {
    return [NSURL URLWithString: @"http://localhost:8080"];
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

- (RKResponseDescriptor *)tokenDescriptor {
    RKObjectMapping *tokenMapping = [RKObjectMapping mappingForClass:[OAuth2Token class]];
    [tokenMapping addAttributeMappingsFromDictionary:@{
                                                       @"accessToken":  @"access_token",
                                                       @"refreshToken": @"refresh_token",
                                                       @"tokenType":    @"token_type",
                                                       @"expiresIn":    @"expires_in",
                                                       @"scope":        @"scope"
                                                       }];
    
    NSIndexSet *tokenSuccessfulStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    return [RKResponseDescriptor responseDescriptorWithMapping:tokenMapping
                                                        method:RKRequestMethodPOST
                                                   pathPattern:@"/oauth/token"
                                                       keyPath:nil
                                                   statusCodes:tokenSuccessfulStatusCodes];
    
}

@end
