#import "RTClient.h"
#import "RTRestAPI.h"

#import "RTAuthenticationAwareHTTPClient.h"
#import "RTEndpointPathFormatter.h"

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTAccountRegistration.h"

static NSString *const ALL_SCOPES = @"audiences-read audiences-write reels-read reels-write users-read users-write videos-read videos-write";

@interface RTClient ()

@property RTAuthenticationAwareHTTPClient *httpClient;
@property RTEndpointPathFormatter *pathFormatter;

@end

@implementation RTClient

- (instancetype)initWithHttpClient:(RTAuthenticationAwareHTTPClient *)httpClient
                     pathFormatter:(RTEndpointPathFormatter *)pathFormatter {
    self = [super init];
    if (self) {
        self.httpClient = httpClient;
        self.pathFormatter = pathFormatter;
    }
    return self;
}

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(TokenCallback)success
                           failure:(TokenErrorCallback)failure {
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
                success:(ClientCredentialsCallback)success
                failure:(ServerErrorsCallback)failure {
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

- (void)removeAccountWithSuccess:(NoArgsCallback)success
                         failure:(NoArgsCallback)failure {
    [self.httpClient authenticatedDeleteForPath:API_REMOVE_ACCOUNT
                                 withParameters:nil
                                        success:success
                                        failure:failure];
}

- (void)registerClientWithClientName:(NSString *)clientName
                     userCredentials:(RTUserCredentials *)userCredentials
                             success:(ClientCredentialsCallback)success
                             failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{
                                 @"username":       userCredentials.username,
                                 @"password":       userCredentials.password,
                                 @"client_name":    clientName
                                 };
    [self.httpClient unauthenticatedPostForPath:API_REGISTER_CLIENT
                                 withParameters:parameters
                                        success:success
                                        failure:failure];
}

- (void)removeClientWithClientId:(NSString *)clientId
                         success:(NoArgsCallback)success
                         failure:(NoArgsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_REMOVE_CLIENT withClientId:clientId];
    [self.httpClient authenticatedDeleteForPath:path
                                 withParameters:nil
                                        success:success
                                        failure:failure];
}

- (void)confirmAccountWithCode:(NSString *)code
                       success:(NoArgsCallback)success
                       failure:(NoArgsCallback)failure {
    NSDictionary *parameters = @{@"code": code};
    [self.httpClient authenticatedPostForPath:API_CONFIRM_ACCOUNT
                               withParameters:parameters
                                      success:success
                                      failure:failure];
}

- (void)sendAccountConfirmationEmailWithSuccess:(NoArgsCallback)success
                                        failure:(NoArgsCallback)failure {
    [self.httpClient authenticatedPostForPath:API_CONFIRM_ACCOUNT_SEND_EMAIL
                               withParameters:nil
                                      success:success
                                      failure:failure];
}

- (void)changeDisplayName:(NSString *)displayName
                  success:(NoArgsCallback)success
                  failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"new_display_name": displayName};
    [self.httpClient authenticatedPostForPath:API_CHANGE_DISPLAY_NAME
                               withParameters:parameters
                                      success:success
                                      failure:failure];
}

- (void)changePassword:(NSString *)password
               success:(NoArgsCallback)success
               failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"new_password": password};
    [self.httpClient authenticatedPostForPath:API_CHANGE_PASSWORD
                               withParameters:parameters
                                      success:success
                                      failure:failure];
}

- (void)resetPasswordWithCode:(NSString *)code
              userCredentials:(RTUserCredentials *)userCredentials
            clientCredentials:(RTClientCredentials *)clientCredentials
                      success:(NoArgsCallback)success
                      failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{
                                 @"username":               userCredentials.username,
                                 @"new_password":           userCredentials.password,
                                 @"code":                   code,
                                 @"client_is_registered":   @(YES),
                                 @"client_id":              clientCredentials.clientId,
                                 @"client_secret":          clientCredentials.clientSecret
                                 };

    [self.httpClient unauthenticatedPostForPath:API_RESET_PASSWORD
                                 withParameters:parameters
                                        success:success
                                        failure:failure];
}

- (void)resetPasswordWithCode:(NSString *)code
              userCredentials:(RTUserCredentials *)userCredentials
                   clientName:(NSString *)clientName
                      success:(ClientCredentialsCallback)success
                      failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{
                                 @"username":               userCredentials.username,
                                 @"new_password":           userCredentials.password,
                                 @"code":                   code,
                                 @"client_is_registered":   @(NO),
                                 @"client_name":            clientName
                                 };
    
    [self.httpClient unauthenticatedPostForPath:API_RESET_PASSWORD
                                 withParameters:parameters
                                        success:success
                                        failure:failure];
}

- (void)sendResetPasswordEmailWithSuccess:(NoArgsCallback)success
                                  failure:(NoArgsCallback)failure {
    [self.httpClient unauthenticatedPostForPath:API_RESET_PASSWORD_SEND_EMAIL
                                 withParameters:nil
                                        success:success
                                        failure:failure];
}

- (void)newsfeedPage:(NSUInteger)page
             success:(NewsfeedCallback)success
             failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"page": @(page)};
    [self.httpClient authenticatedGetForPath:API_NEWSFEED
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)listReelsPage:(NSUInteger)page
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"page": @(page)};
    [self.httpClient authenticatedGetForPath:API_LIST_REELS
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)addReelWithName:(NSString *)name
                success:(ReelCallback)success
                failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"name": name};
    [self.httpClient authenticatedPostForPath:API_ADD_REEL
                               withParameters:parameters
                                      success:success
                                      failure:failure];
    
}

- (void)reelForReelId:(NSUInteger)reelId
              success:(ReelCallback)success
              failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_GET_REEL withReelId:reelId];
    [self.httpClient authenticatedGetForPath:path
                              withParameters:nil
                                     success:success
                                     failure:failure];
}

- (void)deleteReelForReelId:(NSUInteger)reelId
                    success:(NoArgsCallback)success
                    failure:(NoArgsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_DELETE_REEL withReelId:reelId];
    [self.httpClient authenticatedDeleteForPath:path
                                 withParameters:nil
                                        success:success
                                        failure:failure];                            
}

- (void)listVideosPage:(NSUInteger)page
             forReelId:(NSUInteger)reelId
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"page": @(page)};
    NSString *path = [self.pathFormatter formatPath:API_LIST_REEL_VIDEOS withReelId:reelId];
    
    [self.httpClient authenticatedGetForPath:path
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)listAudienceMembersPage:(NSUInteger)page
                      forReelId:(NSUInteger)reelId
                        success:(UserListCallback)success
                        failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"page": @(page)};
    NSString *path = [self.pathFormatter formatPath:API_LIST_AUDIENCE_MEMBERS withReelId:reelId];

    [self.httpClient authenticatedGetForPath:path
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)joinAudienceForReelId:(NSUInteger)reelId
                      success:(NoArgsCallback)success
                      failure:(NoArgsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_ADD_AUDIENCE_MEMBER withReelId:reelId];
    [self.httpClient authenticatedPostForPath:path
                               withParameters:nil
                                      success:success
                                      failure:failure];
}

- (void)leaveAudienceForReelId:(NSUInteger)reelId
                       success:(NoArgsCallback)success
                       failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_REMOVE_AUDIENCE_MEMBER withReelId:reelId];
    [self.httpClient authenticatedDeleteForPath:path
                                 withParameters:nil
                                        success:success
                                        failure:failure];
    
}

- (void)followUserForUsername:(NSString *)username
                      success:(NoArgsCallback)success
                      failure:(void (^)(RTServerErrors *errors))failure {
    NSString *path = [self.pathFormatter formatPath:API_FOLLOW_USER withUsername:username];
    [self.httpClient authenticatedPostForPath:path
                               withParameters:nil
                                      success:success
                                      failure:failure];
}

- (void)unfollowUserForUsername:(NSString *)username
                        success:(NoArgsCallback)success
                        failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_UNFOLLOW_USER withUsername:username];
    [self.httpClient authenticatedDeleteForPath:path
                                 withParameters:nil
                                        success:success
                                        failure:failure];
}

@end

