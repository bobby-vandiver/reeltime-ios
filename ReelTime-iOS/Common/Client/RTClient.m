#import "RTClient.h"
#import "RTClientDelegate.h"

#import "RTEndpointPathFormatter.h"
#import "RTRestAPI.h"

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTAccountRegistration.h"

#import <RestKit/RestKit.h>
#import "RKObjectManager+IncludeHeaders.h"

static NSString *const ALL_SCOPES = @"audiences-read audiences-write reels-read reels-write users-read users-write videos-read videos-write";

static NSString *const AUTHORIZATION_HEADER = @"Authorization";

@interface RTClient ()

@property RTClientDelegate *delegate;
@property RTEndpointPathFormatter *pathFormatter;
@property RKObjectManager *objectManager;

@end

@implementation RTClient

- (instancetype)initWithDelegate:(RTClientDelegate *)delegate
                   pathFormatter:(RTEndpointPathFormatter *)pathFormatter
            restKitObjectManager:(RKObjectManager *)objectManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.pathFormatter = pathFormatter;
        self.objectManager = objectManager;
    }
    return self;
}

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(void (^)(RTOAuth2Token *))success
                           failure:(void (^)(RTOAuth2TokenError *))failure {
    NSDictionary *parameters = @{
                                 @"grant_type":      @"password",
                                 @"username":        userCredentials.username,
                                 @"password":        userCredentials.password,
                                 @"client_id":       clientCredentials.clientId,
                                 @"client_secret":   clientCredentials.clientSecret,
                                 @"scope":           ALL_SCOPES
                                 };
    
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RTOAuth2Token *token = [mappingResult firstObject];
        success(token);
    };
    
    id failureCallback = ^(RKObjectRequestOperation *operation, NSError *error) {
        RTOAuth2TokenError *tokenError = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        failure(tokenError);
    };
    
    [self.objectManager postObject:nil
                              path:API_TOKEN
                        parameters:parameters
                           success:successCallback
                           failure:failureCallback];
}

- (void)registerAccount:(RTAccountRegistration *)registration
                success:(void (^)(RTClientCredentials *))success
                failure:(void (^)(RTServerErrors *))failure {
    NSDictionary *parameters = @{
                                 @"username":       registration.username,
                                 @"password":       registration.password,
                                 @"email":          registration.email,
                                 @"display_name":   registration.displayName,
                                 @"client_name":    registration.clientName
                                 };
    
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RTClientCredentials *clientCredentials = [mappingResult firstObject];
        success(clientCredentials);
    };
    
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    [self.objectManager postObject:nil
                              path:API_REGISTER_ACCOUNT
                        parameters:parameters
                           success:successCallback
                           failure:failureCallback];
}

- (void)removeAccountWithSuccess:(void (^)())success
                         failure:(void (^)(RTServerErrors *))failure {
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    };
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    [self authenticatedDeleteForEndpoint:API_REMOVE_ACCOUNT withParameters:nil success:successCallback failure:failureCallback];
}

- (void)registerClientWithClientName:(NSString *)clientName
                     userCredentials:(RTUserCredentials *)userCredentials
                             success:(void (^)(RTClientCredentials *))success
                             failure:(void (^)(RTServerErrors *))failure {
    NSDictionary *parameters = @{
                                 @"username":   userCredentials.username,
                                 @"password":   userCredentials.password,
                                 @"client_id":  clientName
                                 };
    
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RTClientCredentials *clientCredentials = [mappingResult firstObject];
        success(clientCredentials);
    };
    
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    [self.objectManager postObject:nil
                              path:API_REGISTER_CLIENT
                        parameters:parameters
                           success:successCallback
                           failure:failureCallback];
}

- (void)newsfeedPage:(NSUInteger)page
             success:(void (^)(RTNewsfeed *))success
             failure:(void (^)(RTServerErrors *))failure {
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RTNewsfeed *newsfeed = [mappingResult firstObject];
        success(newsfeed);
    };
    
    id failureCallback = [self serverFailureHandlerWithCallback:failure];

    NSDictionary *parameters = @{@"page":@(page)};
    [self authenticatedGetForEndpoint:API_NEWSFEED withParameters:parameters success:successCallback failure:failureCallback];
}

- (void)joinAudienceForReelId:(NSUInteger)reelId
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *))failure {
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    };
    
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    NSString *endpoint = [self.pathFormatter formatPath:API_ADD_AUDIENCE_MEMBER withParameters:@{@":reel_id": @(reelId)}];
    [self authenticatedPostForEndpoint:endpoint withParameters:nil success:successCallback failure:failureCallback];
}

- (void)followUserForUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *))failure {
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    };
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    NSString *endpoint = [self.pathFormatter formatPath:API_FOLLOW_USER withParameters:@{@":username": username}];
    [self authenticatedPostForEndpoint:endpoint withParameters:nil success:successCallback failure:failureCallback];
}

- (void)authenticatedGetForEndpoint:(NSString *)endpoint
                     withParameters:(NSDictionary *)parameters
                            success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))succcess
                            failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {

    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self.objectManager getObject:nil
                             path:endpoint
                       parameters:parameters
                          headers:headers
                          success:succcess
                          failure:failure];
}

- (void)authenticatedPostForEndpoint:(NSString *)endpoint
                      withParameters:(NSDictionary *)parameters
                             success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))succcess
                             failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {

    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self.objectManager postObject:nil
                              path:endpoint
                        parameters:parameters
                           headers:headers
                           success:succcess
                           failure:failure];
}

- (void)authenticatedDeleteForEndpoint:(NSString *)endpoint
                        withParameters:(NSDictionary *)parameters
                               success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))succcess
                               failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {

    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self.objectManager deleteObject:nil
                                path:endpoint
                          parameters:parameters
                             headers:headers
                             success:succcess
                             failure:failure];
}

- (NSString *)formatAccessTokenForAuthorizationHeader {
    NSString *token = [self.delegate accessTokenForCurrentUser];
    return [NSString stringWithFormat:@"Bearer %@", token];
}

- (void (^)(RKObjectRequestOperation *, NSError *))serverFailureHandlerWithCallback:(void (^)(RTServerErrors *))callback {
    return ^(RKObjectRequestOperation *operation, NSError *error) {
        RTServerErrors *serverErrors = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        callback(serverErrors);
    };
}

@end

