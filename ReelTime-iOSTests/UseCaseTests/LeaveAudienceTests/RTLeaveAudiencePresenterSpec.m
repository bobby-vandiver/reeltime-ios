#import "RTTestCommon.h"

#import "RTLeaveAudiencePresenter.h"

#import "RTLeaveAudienceView.h"
#import "RTLeaveAudienceInteractor.h"

#import "RTLeaveAudienceError.h"
#import "RTErrorFactory.h"

SpecBegin(RTLeaveAudiencePresenter)

describe(@"leave audience presenter", ^{
    
    __block RTLeaveAudiencePresenter *presenter;
    
    __block id<RTLeaveAudienceView> view;
    __block RTLeaveAudienceInteractor *interactor;

    beforeEach(^{
        view = mockProtocol(@protocol(RTLeaveAudienceView));
        interactor = mock([RTLeaveAudienceInteractor class]);
        
        presenter = [[RTLeaveAudiencePresenter alloc] initWithView:view
                                                        interactor:interactor];
    });
    
    describe(@"requesting audience membership leave", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedAudienceMembershipLeaveForReelId:@(reelId)];
            [verify(interactor) leaveAudienceForReelId:@(reelId)];
        });
    });
    
    describe(@"leave audience succeeded", ^{
        it(@"should show audience as not joined", ^{
            [presenter leaveAudienceSucceededForReelId:@(reelId)];
            [verify(view) showAudienceAsNotJoinedForReelId:@(reelId)];
        });
    });
    
    describe(@"leave audience failed", ^{
        it(@"reel not found", ^{
            NSError *error = [RTErrorFactory leaveAudienceErrorWithCode:RTLeaveAudienceErrorReelNotFound];
            
            [presenter leaveAudienceFailedForReelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Cannot leave audience of an unknown reel!"];
        });
        
        it(@"unknown audience error", ^{
            NSError *error = [RTErrorFactory leaveAudienceErrorWithCode:RTLeaveAudienceErrorUnknownError];
            
            [presenter leaveAudienceFailedForReelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while leaving audience. Please try again."];
        });
    });
});

SpecEnd
