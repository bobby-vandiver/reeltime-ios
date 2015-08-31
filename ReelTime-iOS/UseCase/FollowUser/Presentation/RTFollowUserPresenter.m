#import "RTFollowUserPresenter.h"

#import "RTFollowUserView.h"
#import "RTFollowUserInteractor.h"
#import "RTFollowUserError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTFollowUserErrorCodeToErrorMessageMapping.h"

#import "RTLogging.h"

@interface RTFollowUserPresenter ()

@property id<RTFollowUserView> view;
@property RTFollowUserInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTFollowUserPresenter

- (instancetype)initWithView:(id<RTFollowUserView>)view
                  interactor:(RTFollowUserInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTFollowUserErrorCodeToErrorMessageMapping *mapping = [[RTFollowUserErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
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
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
