#import "RTClient.h"
#import "RTClientDelegate.h"

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
@property RKObjectManager *objectManager;

@end

@implementation RTClient

- (instancetype)initWithDelegate:(RTClientDelegate *)delegate
            RestKitObjectManager:(RKObjectManager *)objectManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
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
                              path:API_TOKEN_ENDPOINT
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
                              path:API_ACCOUNT_REGISTRATION_ENDPOINT
                        parameters:parameters
                           success:successCallback
                           failure:failureCallback];
}

- (void)newsfeedPage:(NSUInteger)page
             success:(void (^)(RTNewsfeed *))success
             failure:(void (^)(RTServerErrors *))failure {
    NSDictionary *parameters = @{@"page":@(page)};
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};

    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RTNewsfeed *newsfeed = [mappingResult firstObject];
        success(newsfeed);
    };
    
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    [self.objectManager getObject:nil
                             path:API_NEWSFEED_ENDPOINT
                       parameters:parameters
                          headers:headers
                          success:successCallback
                          failure:failureCallback];
}

- (void)joinAudienceForReelId:(NSUInteger)reelId
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *))failure {
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    
    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    };
    
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    NSString *endpoint = [self formatPath:API_JOIN_REEL_AUDIENCE_ENDPOINT withParameters:@{@":reel_id": @(reelId)}];
    [self.objectManager postObject:nil
                              path:endpoint
                        parameters:nil
                           headers:headers
                           success:successCallback
                           failure:failureCallback];
}

- (void)followUserForUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *))failure {
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};

    id successCallback = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    };
    
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    NSString *endpoint = [self formatPath:API_FOLLOW_USER_ENDPOINT withParameters:@{@":username": username}];
    [self.objectManager postObject:nil
                              path:endpoint
                        parameters:nil
                           headers:headers
                           success:successCallback
                           failure:failureCallback];
    
}

- (NSString *)formatPath:(NSString *)path
          withParameters:(NSDictionary *)parameters {
    NSString *formattedPath = [path copy];
    
    for (NSString *key in [parameters allKeys]) {
        NSString *value = [NSString stringWithFormat:@"%@", parameters[key]];
        formattedPath = [formattedPath stringByReplacingOccurrencesOfString:key withString:value];
    }
    
    return formattedPath;
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

