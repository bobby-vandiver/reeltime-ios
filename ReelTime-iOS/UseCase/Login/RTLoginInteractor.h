#import <Foundation/Foundation.h>

#import "RTClient.h"
#import "RTClientCredentialsStore.h"
#import "RTOAuth2TokenStore.h"
#import "RTCurrentUserStore.h"

@class RTLoginPresenter;

@interface RTLoginInteractor : NSObject

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                           client:(RTClient *)client
           clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                       tokenStore:(RTOAuth2TokenStore *)tokenStore
                 currentUserStore:(RTCurrentUserStore *)currentUserStore;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
