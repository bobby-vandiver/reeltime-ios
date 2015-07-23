#import "RTFollowUserInteractor.h"

#import "RTFollowUserInteractorDelegate.h"
#import "RTFollowUserDataManager.h"

#import "RTFollowUserError.h"
#import "RTErrorFactory.h"

@interface RTFollowUserInteractor ()

@property id<RTFollowUserInteractorDelegate> delegate;
@property RTFollowUserDataManager *dataManager;

@end

@implementation RTFollowUserInteractor

- (instancetype)initWithDelegate:(id<RTFollowUserInteractorDelegate>)delegate
                     dataManager:(RTFollowUserDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)followUserWithUsername:(NSString *)username {
    if (username != nil) {
        [self.dataManager followUserWithUsername:username
                                   followSuccess:[self followUserSuccessCallbackWithUsername:username]
                                   followFailure:[self followUserFailureCallbackWithUsername:username]];
    }
    else {
        NSError *error = [RTErrorFactory followUserErrorWithCode:RTFollowUserErrorUserNotFound];
        [self.delegate followUserFailedForUsername:username withError:error];
    }
}

- (NoArgsCallback)followUserSuccessCallbackWithUsername:(NSString *)username {
    return ^{
        [self.delegate followUserSucceededForUsername:username];
    };
}

- (ErrorCallback)followUserFailureCallbackWithUsername:(NSString *)username {
    return ^(NSError *error) {
        [self.delegate followUserFailedForUsername:username withError:error];
    };
}

@end
