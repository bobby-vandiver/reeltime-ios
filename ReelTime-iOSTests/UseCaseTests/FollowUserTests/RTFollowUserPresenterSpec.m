#import "RTTestCommon.h"

#import "RTFollowUserPresenter.h"

#import "RTFollowUserView.h"
#import "RTFollowUserInteractor.h"

#import "RTFollowUserError.h"
#import "RTErrorFactory.h"

SpecBegin(RTFollowUserPresenter)

describe(@"follow user presenter", ^{
    
    __block RTFollowUserPresenter *presenter;
    
    __block id<RTFollowUserView> view;
    __block RTFollowUserInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTFollowUserView));
        interactor = mock([RTFollowUserInteractor class]);
        
        presenter = [[RTFollowUserPresenter alloc] initWithView:view
                                                     interactor:interactor];
    });
    
    describe(@"requesting user following", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedUserFollowingForUsername:username];
            [verify(interactor) followUserWithUsername:username];
        });
    });
    
    describe(@"follow user succeeded", ^{
        it(@"should show user as being followed", ^{
            [presenter followUserSucceededForUsername:username];
            [verify(view) showUserAsFollowedForUsername:username];
        });
    });
    
    describe(@"follow user failed", ^{
        it(@"user not found", ^{
            NSError *error = [RTErrorFactory followUserErrorWithCode:RTFollowUserErrorUserNotFound];
            
            [presenter followUserFailedForUsername:username withError:error];
            [verify(view) showErrorMessage:@"Cannot follow an unknown user!"];
        });
        
        it(@"unknown follow error", ^{
            NSError *error = [RTErrorFactory followUserErrorWithCode:RTFollowUserErrorUnknownError];
            
            [presenter followUserFailedForUsername:username withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while following user. Please try again."];
        });
        
        // TODO
        xit(@"general unknown error", ^{
            NSError *error = [NSError errorWithDomain:@"unknown" code:1 userInfo:nil];
            
            [presenter followUserFailedForUsername:username withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while following user. Please try again."];
        });
    });
});

SpecEnd
