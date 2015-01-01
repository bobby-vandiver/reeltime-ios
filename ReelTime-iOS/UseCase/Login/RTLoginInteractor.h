#import <Foundation/Foundation.h>

#import "RTLoginPresenter.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"
#import "RTOAuth2TokenStore.h"

@interface RTLoginInteractor : NSObject

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                           client:(RTClient *)client
           clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                       tokenStore:(RTOAuth2TokenStore *)tokenStore;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
