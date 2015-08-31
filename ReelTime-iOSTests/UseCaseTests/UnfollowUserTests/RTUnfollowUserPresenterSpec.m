#import "RTTestCommon.h"

#import "RTUnfollowUserPresenter.h"

#import "RTUnfollowUserView.h"
#import "RTUnfollowUserInteractor.h"

#import "RTUnfollowUserError.h"
#import "RTErrorFactory.h"

SpecBegin(RTUnfollowUserPresenter)

describe(@"unfollow user presenter", ^{
    
    __block RTUnfollowUserPresenter *presenter;
    
    __block id<RTUnfollowUserView> view;
    __block RTUnfollowUserInteractor *interactor;
    
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTUnfollowUserView));
        interactor = mock([RTUnfollowUserInteractor class]);
        
        presenter = [[RTUnfollowUserPresenter alloc] initWithView:view
                                                       interactor:interactor];
    });
    
    describe(@"requesting user unfollowing", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedUserUnfollowingForUsername:username];
            [verify(interactor) unfollowUserWithUsername:username];
        });
    });
    
    describe(@"unfollow user succeeded", ^{
        it(@"should show user as being unfollowed", ^{
            [presenter unfollowUserSucceededForUsername:username];
            [verify(view) showUserAsUnfollowedForUsername:username];
        });
    });
    
    describe(@"unfollow user failed", ^{
        it(@"user not found", ^{
            NSError *error = [RTErrorFactory unfollowUserErrorWithCode:RTUnfollowUserErrorUserNotFound];
            
            [presenter unfollowUserFailedForUsername:username withError:error];
            [verify(view) showErrorMessage:@"Cannot unfollow an unknown user!"];
        });
        
        it(@"unknown follow error", ^{
            NSError *error = [RTErrorFactory unfollowUserErrorWithCode:RTUnfollowUserErrorUnknownError];
            
            [presenter unfollowUserFailedForUsername:username withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while following user. Please try again."];
        });
    });
});

SpecEnd
