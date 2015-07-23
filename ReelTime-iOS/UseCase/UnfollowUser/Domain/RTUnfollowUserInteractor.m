#import "RTUnfollowUserInteractor.h"

#import "RTUnfollowUserInteractorDelegate.h"
#import "RTUnfollowUserDataManager.h"

#import "RTUnfollowUserError.h"
#import "RTErrorFactory.h"

@interface RTUnfollowUserInteractor ()

@property id<RTUnfollowUserInteractorDelegate> delegate;
@property RTUnfollowUserDataManager *dataManager;

@end

@implementation RTUnfollowUserInteractor

- (instancetype)initWithDelegate:(id<RTUnfollowUserInteractorDelegate>)delegate
                     dataManager:(RTUnfollowUserDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)unfollowUserWithUsername:(NSString *)username {
    if (username != nil) {
        [self.dataManager unfollowUserWithUsername:username
                                   unfollowSuccess:[self unfollowUserSuccessCallbackWithUsername:username]
                                   unfollowFailure:[self unfollowUserFailureCallbackWithUsername:username]];
    }
    else {
        NSError *error = [RTErrorFactory unfollowUserErrorWithCode:RTUnfollowUserErrorUserNotFound];
        [self.delegate unfollowUserFailedForUsername:username withError:error];
    }
}

- (NoArgsCallback)unfollowUserSuccessCallbackWithUsername:(NSString *)username {
    return ^{
        [self.delegate unfollowUserSucceededForUsername:username];
    };
}

- (ErrorCallback)unfollowUserFailureCallbackWithUsername:(NSString *)username {
    return ^(NSError *error) {
        [self.delegate unfollowUserFailedForUsername:username withError:error];
    };
}

@end
