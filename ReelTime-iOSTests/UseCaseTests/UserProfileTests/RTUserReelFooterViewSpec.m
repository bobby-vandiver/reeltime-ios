#import "RTTestCommon.h"

#import "RTUserReelFooterView.h"
#import "RTUserReelFooterViewDelegate.h"

SpecBegin(RTUserReelFooterView)

describe(@"user reel footer view", ^{
    
    __block RTUserReelFooterView *footerView;
    __block id<RTUserReelFooterViewDelegate> delegate;
    
    __block UIButton *followReelButton;
    __block UIButton *listAudienceButton;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTUserReelFooterViewDelegate));
        
        followReelButton = mock([UIButton class]);
        listAudienceButton = mock([UIButton class]);
        
        footerView = [[RTUserReelFooterView alloc] init];

        footerView.delegate = delegate;
        footerView.reelId = @(reelId);
        footerView.followReelButton = followReelButton;
        footerView.listAudienceButton = listAudienceButton;
    });
    
    describe(@"pressing follow reel button", ^{
        it(@"should notify delegate", ^{
            [footerView pressedFollowReelButton];
            [verify(delegate) footerView:footerView didPressFollowReelButton:followReelButton forReelId:@(reelId)];
        });
    });
    
    describe(@"pressing list audience button", ^{
        it(@"should notify delegate", ^{
            [footerView pressedListAudienceButton];
            [verify(delegate) footerView:footerView didPressListAudienceButton:listAudienceButton forReelId:@(reelId)];
        });
    });
});

SpecEnd
