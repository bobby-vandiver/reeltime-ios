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

@class RTReel;
@class RTReelList;

@class RTUser;
@class RTUserList;

@class RTVideo;
@class RTVideoList;

typedef void (^NoArgsCallback)();
typedef void (^ServerErrorsCallback)(RTServerErrors *serverErrors);

typedef void (^TokenCallback)(RTOAuth2Token *token);
typedef void (^TokenErrorCallback)(RTOAuth2TokenError *tokenError);

typedef void (^ClientCredentialsCallback)(RTClientCredentials *clientCredentials);
typedef void (^NewsfeedCallback)(RTNewsfeed *newsfeed);

typedef void (^ReelCallback)(RTReel *reel);
typedef void (^ReelListCallback)(RTReelList *reelList);

typedef void (^UserCallback)(RTUser *user);
typedef void (^UserListCallback)(RTUserList *userList);

typedef void (^VideoCallback)(RTVideo *video);
typedef void (^VideoListCallback)(RTVideoList *videoList);

@interface RTClient : NSObject

- (instancetype)initWithHttpClient:(RTAuthenticationAwareHTTPClient *)httpClient
                     pathFormatter:(RTEndpointPathFormatter *)pathFormatter;

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(TokenCallback)success
                           failure:(TokenErrorCallback)failure;

- (void)registerAccount:(RTAccountRegistration *)registration
                success:(ClientCredentialsCallback)success
                failure:(ServerErrorsCallback)failure;

- (void)removeAccountWithSuccess:(NoArgsCallback)success
                         failure:(NoArgsCallback)failure;

- (void)registerClientWithClientName:(NSString *)clientName
                     userCredentials:(RTUserCredentials *)userCredentials
                             success:(ClientCredentialsCallback)success
                             failure:(ServerErrorsCallback)failure;

- (void)removeClientWithClientId:(NSString *)clientId
                         success:(NoArgsCallback)success
                         failure:(NoArgsCallback)failure;

- (void)confirmAccountWithCode:(NSString *)code
                       success:(NoArgsCallback)success
                       failure:(NoArgsCallback)failure;

- (void)sendAccountConfirmationEmailWithSuccess:(NoArgsCallback)success
                                        failure:(NoArgsCallback)failure;

- (void)changeDisplayName:(NSString *)displayName
                  success:(NoArgsCallback)success
                  failure:(ServerErrorsCallback)failure;

- (void)changePassword:(NSString *)password
               success:(NoArgsCallback)success
               failure:(ServerErrorsCallback)failure;

- (void)resetPasswordWithCode:(NSString *)code
              userCredentials:(RTUserCredentials *)userCredentials
            clientCredentials:(RTClientCredentials *)clientCredentials
                      success:(NoArgsCallback)success
                      failure:(ServerErrorsCallback)failure;

- (void)resetPasswordWithCode:(NSString *)code
              userCredentials:(RTUserCredentials *)userCredentials
                   clientName:(NSString *)clientName
                      success:(ClientCredentialsCallback)success
                      failure:(ServerErrorsCallback)failure;

- (void)sendResetPasswordEmailWithSuccess:(NoArgsCallback)success
                                  failure:(NoArgsCallback)failure;

- (void)newsfeedPage:(NSUInteger)page
             success:(NewsfeedCallback)success
             failure:(ServerErrorsCallback)failure;

- (void)listReelsPage:(NSUInteger)page
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure;

- (void)addReelWithName:(NSString *)name
                success:(ReelCallback)success
                failure:(ServerErrorsCallback)failure;

- (void)reelForReelId:(NSUInteger)reelId
              success:(ReelCallback)success
              failure:(ServerErrorsCallback)failure;

- (void)deleteReelForReelId:(NSUInteger)reelId
                    success:(NoArgsCallback)success
                    failure:(NoArgsCallback)failure;

- (void)listVideosPage:(NSUInteger)page
     forReelWithReelId:(NSUInteger)reelId
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure;

- (void)addVideoWithVideoId:(NSUInteger)videoId
           toReelWithReelId:(NSUInteger)reelId
                    success:(NoArgsCallback)success
                    failure:(ServerErrorsCallback)failure;

- (void)removeVideoWithVideoId:(NSUInteger)videoId
            fromReelWithReelId:(NSUInteger)reelId
                       success:(NoArgsCallback)success
                       failure:(ServerErrorsCallback)failure;

- (void)listAudienceMembersPage:(NSUInteger)page
              forReelWithReelId:(NSUInteger)reelId
                        success:(UserListCallback)success
                        failure:(ServerErrorsCallback)failure;

- (void)joinAudienceForReelWithReelId:(NSUInteger)reelId
                              success:(NoArgsCallback)success
                              failure:(ServerErrorsCallback)failure;

- (void)leaveAudienceForReelWithReelId:(NSUInteger)reelId
                               success:(NoArgsCallback)success
                               failure:(ServerErrorsCallback)failure;

- (void)listUsersPage:(NSUInteger)page
              success:(UserListCallback)success
              failure:(ServerErrorsCallback)failure;

- (void)listReelsPage:(NSUInteger)page
  forUserWithUsername:(NSString *)username
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure;

- (void)userForUsername:(NSString *)username
                success:(UserCallback)success
                failure:(ServerErrorsCallback)failure;

- (void)followUserForUsername:(NSString *)username
                      success:(NoArgsCallback)success
                      failure:(ServerErrorsCallback)failure;

- (void)unfollowUserForUsername:(NSString *)username
                        success:(NoArgsCallback)success
                        failure:(ServerErrorsCallback)failure;

@end
