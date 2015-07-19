#import "RTTestCommon.h"

#import "RTJoinAudiencePresenter.h"

#import "RTJoinAudienceView.h"
#import "RTJoinAudienceInteractor.h"

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
});

SpecEnd
