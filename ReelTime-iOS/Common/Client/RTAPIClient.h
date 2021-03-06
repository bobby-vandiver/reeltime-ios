#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@interface RTAPIClient : NSObject

- (instancetype)initWithHttpClient:(RTAuthenticationAwareHTTPClient *)httpClient
                     pathFormatter:(RTEndpointPathFormatter *)pathFormatter;

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(TokenCallback)success
                           failure:(TokenErrorCallback)failure;

- (void)refreshToken:(RTOAuth2Token *)token
withClientCredentials:(RTClientCredentials *)clientCredentials
             success:(TokenCallback)success
             failure:(TokenErrorCallback)failure;

- (void)registerAccount:(RTAccountRegistration *)registration
                success:(ClientCredentialsCallback)success
                failure:(ServerErrorsCallback)failure;

- (void)removeAccountWithSuccess:(NoArgsCallback)success
                         failure:(ServerErrorsCallback)failure;

- (void)listClientsPage:(NSUInteger)page
                success:(ClientListCallback)success
                failure:(ServerErrorsCallback)failure;

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
                                        failure:(ServerErrorsCallback)failure;

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

- (void)sendResetPasswordEmailForUsername:(NSString *)username
                                  success:(NoArgsCallback)success
                                  failure:(ServerErrorsCallback)failure;

- (void)newsfeedPage:(NSUInteger)page
             success:(NewsfeedCallback)success
             failure:(ServerErrorsCallback)failure;

- (void)revokeAccessToken:(NSString *)token
                  success:(NoArgsCallback)success
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

- (void)userForUsername:(NSString *)username
                success:(UserCallback)success
                failure:(ServerErrorsCallback)failure;

- (void)listReelsPage:(NSUInteger)page
  forUserWithUsername:(NSString *)username
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure;

- (void)followUserForUsername:(NSString *)username
                      success:(NoArgsCallback)success
                      failure:(ServerErrorsCallback)failure;

- (void)unfollowUserForUsername:(NSString *)username
                        success:(NoArgsCallback)success
                        failure:(ServerErrorsCallback)failure;

- (void)listFollowersPage:(NSUInteger)page
      forUserWithUsername:(NSString *)username
                  success:(UserListCallback)success
                  failure:(ServerErrorsCallback)failure;

- (void)listFolloweesPage:(NSUInteger)page
      forUserWithUsername:(NSString *)username
                  success:(UserListCallback)success
                  failure:(ServerErrorsCallback)failure;

- (void)listVideosPage:(NSUInteger)page
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure;

- (void)addVideoFromFileURL:(NSURL *)videoFileURL
       thumbnailFromFileURL:(NSURL *)thumbnailFileURL
                  withTitle:(NSString *)title
             toReelWithName:(NSString *)reelName
                    success:(VideoCallback)success
                    failure:(ServerErrorsCallback)failure;

- (void)videoForVideoId:(NSUInteger)videoId
                success:(VideoCallback)success
                failure:(ServerErrorsCallback)failure;

- (void)deleteVideoForVideoId:(NSUInteger)videoId
                      success:(NoArgsCallback)success
                      failure:(ServerErrorsCallback)failure;

- (void)thumbnailForVideoId:(NSUInteger)videoId
             withResolution:(NSString *)resolution
                    success:(ThumbnailCallback)success
                    failure:(ServerErrorsCallback)failure;

@end
