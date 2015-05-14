#import <Foundation/Foundation.h>

@class RTClientCredentials;

@class RTCurrentUserStore;
@class RTClientCredentialsStore;

@interface RTCurrentUserService : NSObject

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                  clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (NSString *)currentUsername;

- (RTClientCredentials *)clientCredentialsForCurrentUser;

@end
