#import "RTLogoutInteractor.h"

#import "RTLogoutInteractorDelegate.h"
#import "RTLogoutDataManager.h"

#import "RTLogging.h"

@interface RTLogoutInteractor ()

@property id<RTLogoutInteractorDelegate> delegate;
@property RTLogoutDataManager *dataManager;

@end

@implementation RTLogoutInteractor

- (instancetype)initWithDelegate:(id<RTLogoutInteractorDelegate>)delegate
                     dataManager:(RTLogoutDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)logout {
    [self.dataManager revokeCurrentTokenWithSuccess:[self tokenRevocationSuccess]
                                            failure:[self tokenRevocationFailure]];
}

- (NoArgsCallback)tokenRevocationSuccess {
    return ^{
        [self.dataManager removeLocalCredentialsWithSuccess:[self removeLocalCredentialsSuccess]
                                                    failure:[self removeLocalCredentialsFailure]];
    };
}

- (ErrorCallback)tokenRevocationFailure {
    return ^(NSError *error) {
        DDLogWarn(@"Token revocation failed: %@", error);
        [self.delegate logoutFailed];
    };
}

- (NoArgsCallback)removeLocalCredentialsSuccess {
    return ^{
        [self.delegate logoutSucceeded];
    };
}

- (ErrorCallback)removeLocalCredentialsFailure {
    return ^(NSError *error) {
        DDLogWarn(@"Failed to remove local credentials: %@", error);
        [self.delegate logoutFailed];
    };
}

@end
