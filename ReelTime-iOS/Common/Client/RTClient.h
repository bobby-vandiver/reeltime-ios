#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class RTClientCredentials;
@class RTUserCredentials;

@class RTOAuth2Token;
@class RTOAuth2TokenError;

@class RTAccountRegistration;

@interface RTClient : NSObject

- (instancetype)initWithRestKitObjectManager:(RKObjectManager *)objectManager;

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(void (^)(RTOAuth2Token *token))success
                           failure:(void (^)(RTOAuth2TokenError *error))failure;

- (void)registerAccount:(RTAccountRegistration *)registration
                success:(void (^)(RTClientCredentials *clientCredentials))success
                failure:(void (^)(NSError *error))failure;

@end
