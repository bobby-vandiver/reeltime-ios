#import "RTClient.h"
#import "RTClientDelegate.h"

#import "RTEndpointPathFormatter.h"
#import "RTRestAPI.h"

#import "RTAuthenticationAwareHTTPClient.h"

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTAccountRegistration.h"

static NSString *const ALL_SCOPES = @"audiences-read audiences-write reels-read reels-write users-read users-write videos-read videos-write";

@interface RTClient ()

@property RTClientDelegate *delegate;
@property RTEndpointPathFormatter *pathFormatter;
@property RTAuthenticationAwareHTTPClient *httpClient;

@end

@implementation RTClient

- (instancetype)initWithDelegate:(RTClientDelegate *)delegate
                   pathFormatter:(RTEndpointPathFormatter *)pathFormatter
                      httpClient:(RTAuthenticationAwareHTTPClient *)httpClient {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.pathFormatter = pathFormatter;
        self.httpClient = httpClient;
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
    
    [self.httpClient unauthenticatedPostForPath:API_TOKEN
                                 withParameters:parameters
                                        success:success
                                        failure:failure];
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
    
    [self.httpClient unauthenticatedPostForPath:API_REGISTER_ACCOUNT
                                 withParameters:parameters
                                        success:success
                                        failure:failure];
}

- (void)removeAccountWithSuccess:(void (^)())success
                         failure:(void (^)(RTServerErrors *))failure {
    [self.httpClient authenticatedDeleteForPath:API_REMOVE_ACCOUNT
                                 withParameters:nil
                                        success:success
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
    [self.httpClient unauthenticatedPostForPath:API_REGISTER_CLIENT
                                 withParameters:parameters
                                        success:success
                                        failure:failure];
}

- (void)newsfeedPage:(NSUInteger)page
             success:(void (^)(RTNewsfeed *))success
             failure:(void (^)(RTServerErrors *))failure {
    NSDictionary *parameters = @{@"page":@(page)};
    [self.httpClient authenticatedGetForPath:API_NEWSFEED
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)joinAudienceForReelId:(NSUInteger)reelId
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *))failure {
    NSString *path = [self.pathFormatter formatPath:API_ADD_AUDIENCE_MEMBER withParameters:@{@":reel_id": @(reelId)}];
    [self.httpClient authenticatedPostForPath:path
                               withParameters:nil
                                      success:success
                                      failure:failure];
}

- (void)followUserForUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *))failure {
    NSString *path = [self.pathFormatter formatPath:API_FOLLOW_USER withParameters:@{@":username": username}];
    [self.httpClient authenticatedPostForPath:path
                               withParameters:nil
                                      success:success
                                      failure:failure];
}

@end

