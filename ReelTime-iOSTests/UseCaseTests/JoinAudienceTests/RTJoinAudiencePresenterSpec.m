#import "RTTestCommon.h"

#import "RTJoinAudiencePresenter.h"

#import "RTJoinAudienceView.h"
#import "RTJoinAudienceInteractor.h"

#import "RTJoinAudienceError.h"
#import "RTErrorFactory.h"

SpecBegin(RTJoinAudiencePresenter)

describe(@"join audience presenter", ^{
    
    __block RTJoinAudiencePresenter *presenter;
    
    __block id<RTJoinAudienceView> view;
    __block RTJoinAudienceInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTJoinAudienceView));
        interactor = mock([RTJoinAudienceInteractor class]);
        
        presenter = [[RTJoinAudiencePresenter alloc] initWithView:view
                                                       interactor:interactor];
    });
    
    describe(@"requesting audience membership", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedAudienceMembershipForReelId:@(reelId)];
            [verify(interactor) joinAudienceForReelId:@(reelId)];
        });
    });
    
    describe(@"join audience succeeded", ^{
        it(@"should show audience as joined", ^{
            [presenter joinAudienceSucceededForReelId:@(reelId)];
            [verify(view) showAudienceAsJoinedForReelId:@(reelId)];
        });
    });
    
    describe(@"join audience failed", ^{
        it(@"reel not found", ^{
            NSError *error = [RTErrorFactory joinAudienceErrorWithCode:RTJoinAudienceErrorReelNotFound];

            [presenter joinAudienceFailedForReelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Cannot join audience of an unknown reel!"];
        });
        
        it(@"unknown audience error", ^{
            NSError *error = [RTErrorFactory joinAudienceErrorWithCode:RTJoinAudienceErrorUnknownError];
            
            [presenter joinAudienceFailedForReelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while joining audience. Please try again."];
        });
        
        it(@"general unknown error", ^{
            NSError *error = [NSError errorWithDomain:@"unknown" code:1 userInfo:nil];
            
            [presenter joinAudienceFailedForReelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while joining audience. Please try again."];
        });
    });
});

SpecEnd
