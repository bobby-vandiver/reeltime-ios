//
//  ReelTimeClient.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "ReelTimeClient.h"
#import "ReelTimeClientErrors.h"
#import "ReelTimeRestAPI.h"

@interface ReelTimeClient ()

@property RKObjectManager *objectManager;

@end

@implementation ReelTimeClient

- (instancetype)initWithRestKitObjectManager:(RKObjectManager *)objectManager {
    self = [super init];
    if (self) {
        self.objectManager = objectManager;
    }
    return self;
}

- (void)tokenWithClientCredentials:(ClientCredentials *)clientCredentials
                   userCredentials:(UserCredentials *)userCredentials
                           success:(TokenSuccessHandler)successHandler
                           failure:(TokenFailureHandler)failureHandler {
    NSDictionary *parameters = @{
        @"grant_type":      @"password",
        @"username":        userCredentials.username,
        @"password":        userCredentials.password,
        @"client_id":       clientCredentials.clientId,
        @"client_secret":   clientCredentials.clientSecret,
        @"scope":           @"TODO"
    };
    
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        OAuth2Token *token = [mappingResult firstObject];
        successHandler(token);
    };
    
    id failureCallback = ^(RKObjectRequestOperation *operation, NSError *error) {
        
    };
    
    [self.objectManager postObject:nil
                              path:API_TOKEN_ENDPOINT
                        parameters:parameters
                           success:successCallback
                           failure:failureCallback];
}

@end
