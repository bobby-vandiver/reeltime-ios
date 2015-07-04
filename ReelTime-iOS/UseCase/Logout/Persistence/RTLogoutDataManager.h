#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;
@class RTOAuth2TokenStore;
@class RTCurrentUserStore;

@interface RTLogoutDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client
                    tokenStore:(RTOAuth2TokenStore *)tokenStore
              currentUserStore:(RTCurrentUserStore *)currentUserStore;

- (void)revokeCurrentTokenWithSuccess:(NoArgsCallback)success
                              failure:(ErrorCallback)failure;

- (void)removeLocalCredentialsWithSuccess:(NoArgsCallback)success
                                  failure:(ErrorCallback)failure;

@end
