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
    
}

- (void)unfollowUserSucceededForUsername:(NSString *)username {
    
}

- (void)unfollowUserFailedForUsername:(NSString *)username
                            withError:(NSError *)error {
    
}

@end
