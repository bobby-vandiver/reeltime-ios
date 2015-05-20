#import <Foundation/Foundation.h>
#import "RTCallback.h"

@protocol RTLoginDataManagerDelegate;

@class RTClient;
@class RTClientCredentialsStore;
@class RTOAuth2TokenStore;
@class RTCurrentUserStore;

@class RTClientCredentials;
@class RTUserCredentials;
@class RTOAuth2Token;

@interface RTLoginDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTLoginDataManagerDelegate>)delegate
                          client:(RTClient *)client
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                      tokenStore:(RTOAuth2TokenStore *)tokenStore
                currentUserStore:(RTCurrentUserStore *)currentUserStore;

- (RTClientCredentials *)clientCredentialsForUsername:(NSString *)username;

- (void)fetchTokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                        userCredentials:(RTUserCredentials *)userCredentials
                               callback:(TokenAndUsernameCallback)callback;

- (void)setLoggedInUserWithToken:(RTOAuth2Token *)token
                        username:(NSString *)username
                        callback:(NoArgsCallback)callback;

@end
