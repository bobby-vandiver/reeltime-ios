#import <Foundation/Foundation.h>

@class RTAuthenticationAwareHTTPClient;
@class RTEndpointPathFormatter;

@class RTClientCredentials;
@class RTUserCredentials;

@class RTOAuth2Token;
@class RTOAuth2TokenError;

@class RTServerErrors;

@class RTAccountRegistration;
@class RTNewsfeed;

@interface RTClient : NSObject

- (instancetype)initWithHttpClient:(RTAuthenticationAwareHTTPClient *)httpClient
                     pathFormatter:(RTEndpointPathFormatter *)pathFormatter;

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(void (^)(RTOAuth2Token *token))success
                           failure:(void (^)(RTOAuth2TokenError *error))failure;

- (void)registerAccount:(RTAccountRegistration *)registration
                success:(void (^)(RTClientCredentials *clientCredentials))success
                failure:(void (^)(RTServerErrors *errors))failure;

- (void)removeAccountWithSuccess:(void (^)())success
                         failure:(void (^)())failure;

- (void)registerClientWithClientName:(NSString *)clientName
                     userCredentials:(RTUserCredentials *)userCredentials
                             success:(void (^)(RTClientCredentials *clientCredentials))success
                             failure:(void (^)(RTServerErrors *errors))failure;

- (void)removeClientWithClientId:(NSString *)clientId
                         success:(void (^)())success
                         failure:(void (^)())failure;

- (void)confirmAccountWithCode:(NSString *)code
                       success:(void (^)())success
                       failure:(void (^)())failure;

- (void)sendAccountConfirmationEmailWithSuccess:(void (^)())success
                                        failure:(void (^)())failure;

- (void)changeDisplayName:(NSString *)displayName
                  success:(void (^)())success
                  failure:(void (^)(RTServerErrors *errors))failure;

- (void)changePassword:(NSString *)password
               success:(void (^)())success
               failure:(void (^)(RTServerErrors *errors))failure;

- (void)newsfeedPage:(NSUInteger)page
             success:(void (^)(RTNewsfeed *newsfeed))success
             failure:(void (^)())failure;

- (void)joinAudienceForReelId:(NSUInteger)reelId
                      success:(void (^)())success
                      failure:(void (^)())failure;

- (void)followUserForUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)())failure;

@end
