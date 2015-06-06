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

@class RTClient;
@class RTClientList;

@class RTReel;
@class RTReelList;

@class RTUser;
@class RTUserList;

@class RTVideo;
@class RTVideoList;

@class RTThumbnail;

typedef void (^NoArgsCallback)();
typedef void (^ServerErrorsCallback)(RTServerErrors *serverErrors);

typedef void (^TokenAndUsernameCallback)(RTOAuth2Token *token, NSString *username);
typedef void (^TokenCallback)(RTOAuth2Token *token);
typedef void (^TokenErrorCallback)(RTOAuth2TokenError *tokenError);

typedef void (^ClientCredentialsCallback)(RTClientCredentials *clientCredentials);
typedef void (^NewsfeedCallback)(RTNewsfeed *newsfeed);

typedef void (^ClientCallback)(RTClient *client);
typedef void (^ClientListCallback)(RTClientList *clientList);

typedef void (^ReelCallback)(RTReel *reel);
typedef void (^ReelListCallback)(RTReelList *reelList);

typedef void (^UserCallback)(RTUser *user);
typedef void (^UserListCallback)(RTUserList *userList);

typedef void (^VideoCallback)(RTVideo *video);
typedef void (^VideoListCallback)(RTVideoList *videoList);

typedef void (^ThumbnailCallback)(RTThumbnail *thumbnail);

typedef void (^ArrayCallback)(NSArray *items);
typedef void (^ErrorCallback)(NSError *error);
