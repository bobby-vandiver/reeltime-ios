#import <Foundation/Foundation.h>

@class RTClientDelegate;
@class RKObjectManager;

@class RTClientCredentials;
@class RTUserCredentials;

@class RTOAuth2Token;
@class RTOAuth2TokenError;

@class RTServerErrors;

@class RTAccountRegistration;
@class RTNewsfeed;

@interface RTClient : NSObject

- (instancetype)initWithDelegate:(RTClientDelegate *)delegate
            RestKitObjectManager:(RKObjectManager *)objectManager;

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(void (^)(RTOAuth2Token *token))success
                           failure:(void (^)(RTOAuth2TokenError *error))failure;

- (void)registerAccount:(RTAccountRegistration *)registration
                success:(void (^)(RTClientCredentials *clientCredentials))success
                failure:(void (^)(RTServerErrors *errors))failure;

- (void)newsfeedPage:(NSUInteger)page
             success:(void (^)(RTNewsfeed *newsfeed))success
             failure:(void (^)(RTServerErrors *errors))failure;

- (void)joinAudienceForReelId:(NSUInteger)reelId
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *errors))failure;

- (void)followUserForUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)(RTServerErrors *errors))failure;

@end
