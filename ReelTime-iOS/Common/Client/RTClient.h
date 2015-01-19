#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"
#import "RTOAuth2Token.h"

#import "RTAccountRegistration.h"

@interface RTClient : NSObject

- (instancetype)initWithRestKitObjectManager:(RKObjectManager *)objectManager;

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(void (^)(RTOAuth2Token *token))success
                           failure:(void (^)(NSError *error))failure;

- (void)registerAccount:(RTAccountRegistration *)registration
                success:(void (^)(RTClientCredentials *clientCredentials))success
                failure:(void (^)(NSError *error))failure;

@end
