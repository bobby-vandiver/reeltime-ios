#import <Foundation/Foundation.h>

#import "RTClient.h"
#import "RTClientCredentialsStore.h"
#import "RTOAuth2TokenStore.h"
#import "RTCurrentUserStore.h"

@class RTLoginPresenter;
@class RTLoginDataManager;

@interface RTLoginInteractor : NSObject

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                      dataManager:(RTLoginDataManager *)dataManager
                           client:(RTClient *)client;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
