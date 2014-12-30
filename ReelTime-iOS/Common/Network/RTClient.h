#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"
#import "RTOAuth2Token.h"

@interface RTClient : NSObject

typedef void (^TokenSuccessHandler)(RTOAuth2Token *token);
typedef void (^TokenFailureHandler)(NSError *error);

- (instancetype)initWithRestKitObjectManager:(RKObjectManager *)objectManager;

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(TokenSuccessHandler)successHandler
                           failure:(TokenFailureHandler)failureHandler;

@end
