#import <Foundation/Foundation.h>

#import "RTClient.h"
#import "RTClientCredentialsStore.h"
#import "RTOAuth2TokenStore.h"
#import "RTCurrentUserStore.h"

@class RTLoginInteractor;

@interface RTLoginDataManager : NSObject

- (instancetype)initWithInteractor:(RTLoginInteractor *)interactor
                            client:(RTClient *)client
            clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                        tokenStore:(RTOAuth2TokenStore *)tokenStore
                  currentUserStore:(RTCurrentUserStore *)currentUserStore;

- (RTClientCredentials *)clientCredentialsForUsername:(NSString *)username;

- (void)fetchTokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                        userCredentials:(RTUserCredentials *)userCredentials
                               callback:(void (^)(RTOAuth2Token *token, NSString *username))callback;

- (void)setLoggedInUserWithToken:(RTOAuth2Token *)token
                        username:(NSString *)username
                        callback:(void (^)())callback;

@end
