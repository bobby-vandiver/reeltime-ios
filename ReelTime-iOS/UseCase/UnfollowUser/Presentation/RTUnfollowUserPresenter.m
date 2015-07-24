#import "RTUnfollowUserPresenter.h"

#import "RTUnfollowUserView.h"
#import "RTUnfollowUserInteractor.h"
#import "RTUnfollowUserError.h"

@interface RTUnfollowUserPresenter ()

@property id<RTUnfollowUserView> view;
@property RTUnfollowUserInteractor *interactor;

@end

@implementation RTUnfollowUserPresenter

- (instancetype)initWithView:(id<RTUnfollowUserView>)view
                  interactor:(RTUnfollowUserInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedUserUnfollowingForUsername:(NSString *)username {
    [self.interactor unfollowUserWithUsername:username];
}

- (void)unfollowUserSucceededForUsername:(NSString *)username {
    [self.view showUserAsUnfollowedForUsername:username];
}

- (void)unfollowUserFailedForUsername:(NSString *)username
                            withError:(NSError *)error {

    NSString *const unknownErrorMessage = @"Unknown error occurred while following user. Please try again.";

    if ([error.domain isEqual:RTUnfollowUserErrorDomain]) {
        NSInteger code = error.code;
        
        if (code == RTUnfollowUserErrorUserNotFound) {
            [self.view showErrorMessage:@"Cannot unfollow an unknown user!"];
        }
        else if (code == RTUnfollowUserErrorUnknownError) {
            [self.view showErrorMessage:unknownErrorMessage];
        }
    }
    else {
        [self.view showErrorMessage:unknownErrorMessage];
    }
}

@end
