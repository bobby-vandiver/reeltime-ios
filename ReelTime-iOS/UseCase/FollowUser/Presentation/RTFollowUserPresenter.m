#import "RTFollowUserPresenter.h"

#import "RTFollowUserView.h"
#import "RTFollowUserInteractor.h"
#import "RTFollowUserError.h"

#import "RTLogging.h"

@interface RTFollowUserPresenter ()

@property id<RTFollowUserView> view;
@property RTFollowUserInteractor *interactor;

@end

@implementation RTFollowUserPresenter

- (instancetype)initWithView:(id<RTFollowUserView>)view
                  interactor:(RTFollowUserInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedUserFollowingForUsername:(NSString *)username {
    [self.interactor followUserWithUsername:username];
}

- (void)followUserSucceededForUsername:(NSString *)username {
    [self.view showUserAsFollowedForUsername:username];
}

- (void)followUserFailedForUsername:(NSString *)username
                          withError:(NSError *)error {

    NSString *const unknownErrorMessage = @"Unknown error occurred while following user. Please try again.";
    
    if ([error.domain isEqual:RTFollowUserErrorDomain]) {
        NSInteger code = error.code;
        
        if (code == RTFollowUserErrorUserNotFound) {
            [self.view showErrorMessage:@"Cannot follow an unknown user!"];
        }
        else if (code == RTFollowUserErrorUnknownError) {
            [self.view showErrorMessage:unknownErrorMessage];
        }
    }
    else {
        DDLogWarn(@"Encountered an error outside the %@ domain = %@", RTFollowUserErrorDomain, error);
        [self.view showErrorMessage:unknownErrorMessage];
    }
}

@end
