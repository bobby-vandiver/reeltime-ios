#import <Foundation/Foundation.h>

@class RTCurrentUserStore;
@class RTOAuth2TokenStore;

@interface RTClientDelegate : NSObject

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                              tokenStore:(RTOAuth2TokenStore *)tokenStore;

- (NSString *)accessTokenForCurrentUser;

@end
