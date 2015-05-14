#import "RTCurrentUserService.h"
#import "RTCurrentUserStore.h"

#import "RTClientCredentials.h"
#import "RTClientCredentialsStore.h"

#import "RTLogging.h"

@interface RTCurrentUserService ()

@property RTCurrentUserStore *currentUserStore;
@property RTClientCredentialsStore *clientCredentialsStore;

@end

@implementation RTCurrentUserService

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                  clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore {
    self = [super init];
    if (self) {
        self.currentUserStore = currentUserStore;
        self.clientCredentialsStore = clientCredentialsStore;
    }
    return self;
}

- (NSString *)currentUsername {
    NSError *error;
    NSString *username = [self.currentUserStore loadCurrentUsernameWithError:&error];

    if (!username) {
        DDLogDebug(@"Could not load current username: %@", error);
    }
    
    return username;
}

- (RTClientCredentials *)clientCredentialsForCurrentUser {
    NSString *username = [self currentUsername];
    if (!username) {
        return nil;
    }
    
    NSError *error;
    RTClientCredentials *clientCredentials = [self.clientCredentialsStore loadClientCredentialsForUsername:username error:&error];
    
    if (!clientCredentials) {
        DDLogDebug(@"Could not load client credentials for current username: %@", error);
    }
    
    return clientCredentials;
}

@end
