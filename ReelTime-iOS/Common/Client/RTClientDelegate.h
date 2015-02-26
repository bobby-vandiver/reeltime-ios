#import <Foundation/Foundation.h>

@class RTCurrentUserStore;
@class RTOAuth2TokenStore;

// TODO: Rename to something more appropriate
@interface RTClientDelegate : NSObject

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                              tokenStore:(RTOAuth2TokenStore *)tokenStore;

- (NSString *)accessTokenForCurrentUser;

@end
