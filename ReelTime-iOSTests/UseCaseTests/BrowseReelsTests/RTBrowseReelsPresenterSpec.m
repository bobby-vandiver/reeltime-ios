#import "RTTestCommon.h"

#import "RTBrowseReelsPresenter.h"

#import "RTBrowseReelsView.h"
#import "RTPagedListInteractor.h"
#import "RTReelWireframe.h"

#import "RTReel.h"
#import "RTReelMessage.h"

SpecBegin(RTBrowseReelsPresenter)

describe(@"browse reels presenter", ^{
    
    __block RTBrowseReelsPresenter *presenter;
    
    __block id<RTBrowseReelsView> view;
    __block RTPagedListInteractor *interactor;
    __block id<RTReelWireframe> wireframe;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTBrowseReelsView));
        interactor = mock([RTPagedListInteractor class]);
        wireframe = mockProtocol(@protocol(RTReelWireframe));
        
        presenter = [[RTBrowseReelsPresenter alloc] initWithView:view
                                                      interactor:interactor
                                                       wireframe:wireframe];
    });
    
    describe(@"list reset", ^{
        it(@"should notify view that currently displayed messages should be removed", ^{
            [presenter clearPresentedItems];
            [verify(view) clearReelMessages];
        });
    });
    
    describe(@"show reel message", ^{
        it(@"should show reel message", ^{
            RTReel *reel = [[RTReel alloc] initWithReelId:@(reelId)
                                                     name:@"something"
                                             audienceSize:@(4)
                                           numberOfVideos:@(3)];

            [presenter presentItem:reel];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showReelMessage:[captor capture]];
            
            RTReelMessage *messsage = [captor value];
            expect(messsage).toNot.beNil();
            
            expect(messsage.text).to.equal(@"something");
            expect(messsage.reelId).to.equal(@(reelId));
        });
    });
    
    describe(@"requesting reel details", ^{
        it(@"should present reel", ^{
            [presenter requestedReelDetailsForReelId:@(reelId)];
            [verify(wireframe) presentReelForReelId:@(reelId)];
        });
    });
});

SpecEnd