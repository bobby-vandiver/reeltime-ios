#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"
#import "RTOAuth2Token.h"
#import "RTError.h"

@interface RTClient : NSObject

typedef void (^TokenSuccessHandler)(RTOAuth2Token *token);
typedef void (^TokenFailureHandler)(RTError *error);

- (instancetype)initWithRestKitObjectManager:(RKObjectManager *)objectManager;

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(TokenSuccessHandler)successHandler
                           failure:(TokenFailureHandler)failureHandler;

@end
