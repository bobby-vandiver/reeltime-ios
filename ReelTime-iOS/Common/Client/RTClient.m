#import "RTClient.h"
#import "RTClientErrors.h"

#import "RTRestAPI.h"

#import "RTOAuth2TokenError.h"
#import "RTOAuth2TokenError+RTClientTokenErrorConverter.h"

@interface RTClient ()

@property RKObjectManager *objectManager;

@end

@implementation RTClient

- (instancetype)initWithRestKitObjectManager:(RKObjectManager *)objectManager {
    self = [super init];
    if (self) {
        self.objectManager = objectManager;
    }
    return self;
}

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
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
        RTOAuth2Token *token = [mappingResult firstObject];
        successHandler(token);
    };
    
    id failureCallback = ^(RKObjectRequestOperation *operation, NSError *error) {
        RTOAuth2TokenError *tokenError = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        failureHandler([tokenError convertToClientTokenError]);
    };
    
    [self.objectManager postObject:nil
                              path:API_TOKEN_ENDPOINT
                        parameters:parameters
                           success:successCallback
                           failure:failureCallback];
}

@end

