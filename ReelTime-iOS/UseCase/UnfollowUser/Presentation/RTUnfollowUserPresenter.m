#import "RTUnfollowUserPresenter.h"

#import "RTUnfollowUserView.h"
#import "RTUnfollowUserInteractor.h"
#import "RTUnfollowUserError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTUnfollowUserErrorCodeToErrorMessageMapping.h"

#import "RTLogging.h"

@interface RTUnfollowUserPresenter ()

@property id<RTUnfollowUserView> view;
@property RTUnfollowUserInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTUnfollowUserPresenter

- (instancetype)initWithView:(id<RTUnfollowUserView>)view
                  interactor:(RTUnfollowUserInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTUnfollowUserErrorCodeToErrorMessageMapping *mapping = [[RTUnfollowUserErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
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
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
