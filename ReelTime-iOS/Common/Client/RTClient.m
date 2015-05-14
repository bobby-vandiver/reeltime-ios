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

#import "RTThumbnail.h"
#import "RTLogging.h"

#import <RestKit/RestKit.h>

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

- (void)sendResetPasswordEmailForUsername:(NSString *)username
                                  success:(NoArgsCallback)success
                                  failure:(NoArgsCallback)failure {
    NSDictionary *parameters = @{@"username": username};
    [self.httpClient unauthenticatedPostForPath:API_RESET_PASSWORD_SEND_EMAIL
                                 withParameters:parameters
                                        success:success
                                        failure:failure];
}

- (void)newsfeedPage:(NSUInteger)page
             success:(NewsfeedCallback)success
             failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
    [self.httpClient authenticatedGetForPath:API_NEWSFEED
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)revokeAccessToken:(NSString *)token
                  success:(NoArgsCallback)success
                  failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_REMOVE_TOKEN withAccessToken:token];
    [self.httpClient authenticatedDeleteForPath:path
                                 withParameters:nil
                                        success:success
                                        failure:failure];
}

- (void)listReelsPage:(NSUInteger)page
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
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
     forReelWithReelId:(NSUInteger)reelId
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
    NSString *path = [self.pathFormatter formatPath:API_LIST_REEL_VIDEOS withReelId:reelId];
    
    [self.httpClient authenticatedGetForPath:path
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)addVideoWithVideoId:(NSUInteger)videoId
           toReelWithReelId:(NSUInteger)reelId
                    success:(NoArgsCallback)success
                    failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"video_id": @(videoId)};
    NSString *path = [self.pathFormatter formatPath:API_ADD_REEL_VIDEO withReelId:reelId];
    
    [self.httpClient authenticatedPostForPath:path
                               withParameters:parameters
                                      success:success
                                      failure:failure];
}

- (void)removeVideoWithVideoId:(NSUInteger)videoId
            fromReelWithReelId:(NSUInteger)reelId
                       success:(NoArgsCallback)success
                       failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_REMOVE_REEL_VIDEO
                                         withReelId:reelId
                                            videoId:videoId];
    [self.httpClient authenticatedDeleteForPath:path
                                 withParameters:nil
                                        success:success
                                        failure:failure];
}

- (void)listAudienceMembersPage:(NSUInteger)page
              forReelWithReelId:(NSUInteger)reelId
                        success:(UserListCallback)success
                        failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
    NSString *path = [self.pathFormatter formatPath:API_LIST_AUDIENCE_MEMBERS withReelId:reelId];

    [self.httpClient authenticatedGetForPath:path
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)joinAudienceForReelWithReelId:(NSUInteger)reelId
                              success:(NoArgsCallback)success
                              failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_ADD_AUDIENCE_MEMBER withReelId:reelId];
    [self.httpClient authenticatedPostForPath:path
                               withParameters:nil
                                      success:success
                                      failure:failure];
}

- (void)leaveAudienceForReelWithReelId:(NSUInteger)reelId
                               success:(NoArgsCallback)success
                               failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_REMOVE_AUDIENCE_MEMBER withReelId:reelId];
    [self.httpClient authenticatedDeleteForPath:path
                                 withParameters:nil
                                        success:success
                                        failure:failure];
}

- (void)listUsersPage:(NSUInteger)page
              success:(UserListCallback)success
              failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
    [self.httpClient authenticatedGetForPath:API_LIST_USERS
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)userForUsername:(NSString *)username
                success:(UserCallback)success
                failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_GET_USER withUsername:username];
    [self.httpClient authenticatedGetForPath:path
                              withParameters:nil
                                     success:success
                                     failure:failure];
}

- (void)listReelsPage:(NSUInteger)page
  forUserWithUsername:(NSString *)username
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
    NSString *path = [self.pathFormatter formatPath:API_LIST_USER_REELS withUsername:username];
    
    [self.httpClient authenticatedGetForPath:path
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)followUserForUsername:(NSString *)username
                      success:(NoArgsCallback)success
                      failure:(ServerErrorsCallback)failure {
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

- (void)listFollowersPage:(NSUInteger)page
      forUserWithUsername:(NSString *)username
                  success:(UserListCallback)success
                  failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
    NSString *path = [self.pathFormatter formatPath:API_LIST_FOLLOWERS withUsername:username];
    
    [self.httpClient authenticatedGetForPath:path
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)listFolloweesPage:(NSUInteger)page
      forUserWithUsername:(NSString *)username
                  success:(UserListCallback)success
                  failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
    NSString *path = [self.pathFormatter formatPath:API_LIST_FOLLOWEES withUsername:username];
    
    [self.httpClient authenticatedGetForPath:path
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)listVideosPage:(NSUInteger)page
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = [self parametersWithPage:page];
    [self.httpClient authenticatedGetForPath:API_LIST_VIDEOS
                              withParameters:parameters
                                     success:success
                                     failure:failure];
}

- (void)addVideoFromFileURL:(NSURL *)videoFileURL
       thumbnailFromFileURL:(NSURL *)thumbnailFileURL
                  withTitle:(NSString *)title
             toReelWithName:(NSString *)reelName
                    success:(VideoCallback)success
                    failure:(ServerErrorsCallback)failure {
    NSDictionary *parameters = @{@"title": title, @"reel": reelName};

    MultipartFormDataBlock formData = ^(id<AFMultipartFormData> formData) {
        BOOL success;
        NSError *appendError;

        NSString *videoFileName = [NSString stringWithFormat:@"%@.mp4", title];
        success = [formData appendPartWithFileURL:videoFileURL
                                                  name:@"video"
                                              fileName:videoFileName
                                              mimeType:@"video/mp4"
                                                 error:&appendError];
        
        if (!success) {
            DDLogError(@"Failed to add video part to form data with error: %@", appendError);
        }
        
        NSString *thumbnailFileName = [NSString stringWithFormat:@"%@.png", title];
        success = [formData appendPartWithFileURL:thumbnailFileURL
                                             name:@"thumbnail"
                                         fileName:thumbnailFileName
                                         mimeType:@"image/png"
                                            error:&appendError];
        
        if (!success) {
            DDLogError(@"Failed to add thumbnail part to form data with error: %@", appendError);
        }
    };

    [self.httpClient authenticatedPostForPath:API_ADD_VIDEO
                               withParameters:parameters
                                formDataBlock:formData
                                      success:success
                                      failure:failure];
}

- (void)videoForVideoId:(NSUInteger)videoId
                success:(VideoCallback)success
                failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_GET_VIDEO withVideoId:videoId];
    [self.httpClient authenticatedGetForPath:path
                              withParameters:nil
                                     success:success
                                     failure:failure];
}

- (void)deleteVideoForVideoId:(NSUInteger)videoId
                      success:(NoArgsCallback)success
                      failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_DELETE_VIDEO withVideoId:videoId];
    [self.httpClient authenticatedDeleteForPath:path
                                 withParameters:nil
                                        success:success
                                        failure:failure];
}

- (void)thumbnailForVideoId:(NSUInteger)videoId
             withResolution:(NSString *)resolution
                    success:(ThumbnailCallback)success
                    failure:(ServerErrorsCallback)failure {
    NSString *path = [self.pathFormatter formatPath:API_GET_VIDEO_THUMBNAIL withVideoId:videoId];
    NSDictionary *parameters = @{@"resolution": resolution};
    
    SuccessCallback successDataCallback = ^(NSData *data) {
        RTThumbnail *thumbnail = [[RTThumbnail alloc] initWithData:data];
        success(thumbnail);
    };
    
    [self.httpClient authenticatedGetBinaryForPath:path
                                    withParameters:parameters
                                           success:successDataCallback
                                           failure:failure];
}

- (NSDictionary *)parametersWithPage:(NSUInteger)page {
    return @{@"page": @(page)};
}

@end

