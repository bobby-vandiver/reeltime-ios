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
    
    [self unauthenticatedPostForPath:API_REGISTER_ACCOUNT
                      withParameters:parameters
                             success:^(id firstObject) {
                                 success(firstObject);
                             }
                             failure:failure];
}

- (void)removeAccountWithSuccess:(void (^)())success
                         failure:(void (^)(RTServerErrors *))failure {
    [self authenticatedDeleteForPath:API_REMOVE_ACCOUNT
                      withParameters:nil
                             success:^(id firstObject) {
                                 success();
                             }
                             failure:failure];
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
    [self unauthenticatedPostForPath:API_REGISTER_CLIENT withParameters:parameters success:success failure:failure];
}

- (void)newsfeedPage:(NSUInteger)page
             success:(void (^)(RTNewsfeed *))success
             failure:(void (^)(RTServerErrors *))failure {
    NSDictionary *parameters = @{@"page":@(page)};
    [self authenticatedGetForPath:API_NEWSFEED
                   withParameters:parameters
                          success:^(id firstObject) {
                              success(firstObject);
                          }
                          failure:failure];
}

- (void)joinAudienceForReelId:(NSUInteger)reelId
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *))failure {
    NSString *path = [self.pathFormatter formatPath:API_ADD_AUDIENCE_MEMBER withParameters:@{@":reel_id": @(reelId)}];
    [self authenticatedPostForPath:path
                    withParameters:nil
                           success:^(id firstObject) {
                               success();
                           }
                           failure:failure];
}

- (void)followUserForUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *))failure {
    NSString *path = [self.pathFormatter formatPath:API_FOLLOW_USER withParameters:@{@":username": username}];
    [self authenticatedPostForPath:path
                    withParameters:nil
                           success:^(id firstObject) {
                               success();
                           }
                           failure:failure];
}

- (void)authenticatedGetForPath:(NSString *)path
                 withParameters:(NSDictionary *)parameters
                        success:(void (^)(id firstObject))success
                        failure:(void (^)(RTServerErrors *errors))failure {
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self getForPath:path withParameters:parameters headers:headers success:success failure:failure];
}

- (void)unauthenticatedGetForPath:(NSString *)path
                   withParameters:(NSDictionary *)parameters
                          success:(void (^)(id firstObject))success
                          failure:(void (^)(RTServerErrors *errors))failure {
    [self getForPath:path withParameters:parameters headers:nil success:success failure:failure];
}

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                         success:(void (^)(id firstObject))success
                         failure:(void (^)(RTServerErrors *errors))failure {
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self postForPath:path withParameters:parameters headers:headers success:success failure:failure];
}

- (void)unauthenticatedPostForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(void (^)(id firstObject))success
                           failure:(void (^)(RTServerErrors *errors))failure {
    [self postForPath:path withParameters:parameters headers:nil success:success failure:failure];
}

- (void)authenticatedDeleteForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(void (^)(id firstObject))success
                           failure:(void (^)(RTServerErrors *errors))failure {
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self deleteForPath:path withParameters:parameters headers:headers success:success failure:failure];
}

- (void)getForPath:(NSString *)path
    withParameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(void (^)(id firstObject))success
           failure:(void (^)(RTServerErrors *errors))failure {
    
    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers) {
        [self.objectManager getObject:nil
                                 path:path
                           parameters:parameters
                              headers:headers
                              success:successCallback
                              failure:failureCallback];
    }
    else {
        [self.objectManager getObject:nil
                                 path:path
                           parameters:parameters
                              success:successCallback
                              failure:failureCallback];
    }
}

- (void)postForPath:(NSString *)path
     withParameters:(NSDictionary *)parameters
            headers:(NSDictionary *)headers
            success:(void (^)(id firstObject))success
            failure:(void (^)(RTServerErrors *errors))failure {

    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers) {
        [self.objectManager postObject:nil
                                  path:path
                            parameters:parameters
                               headers:headers
                               success:successCallback
                               failure:failureCallback];
    }
    else {
        [self.objectManager postObject:nil
                                  path:path
                            parameters:parameters
                               success:successCallback
                               failure:failureCallback];
    }
}

- (void)deleteForPath:(NSString *)path
       withParameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
              success:(void (^)(id firstObject))success
              failure:(void (^)(RTServerErrors *errors))failure {
    
    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers) {
        [self.objectManager deleteObject:nil
                                    path:path
                              parameters:parameters
                                 headers:headers
                                 success:successCallback
                                 failure:failureCallback];
    }
    else {
        [self.objectManager deleteObject:nil
                                    path:path
                              parameters:parameters
                                 success:successCallback
                                 failure:failureCallback];
    }
}

- (NSString *)formatAccessTokenForAuthorizationHeader {
    NSString *token = [self.delegate accessTokenForCurrentUser];
    return [NSString stringWithFormat:@"Bearer %@", token];
}

- (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))successHandlerWithCallback:(void (^)(id))callback {
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        id firstObject = [mappingResult firstObject];
        callback(firstObject);
    };
}

- (void (^)(RKObjectRequestOperation *, NSError *))serverFailureHandlerWithCallback:(void (^)(RTServerErrors *errors))callback {
    return ^(RKObjectRequestOperation *operation, NSError *error) {
        RTServerErrors *serverErrors = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        callback(serverErrors);
    };
}

@end

