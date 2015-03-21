#import "RTTestCommon.h"

#import "RTBrowseReelsPresenter.h"

#import "RTBrowseReelsView.h"
#import "RTPagedListInteractor.h"
#import "RTReelWireframe.h"

#import "RTReel.h"
#import "RTReelDescription.h"

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
        it(@"should notify view that currently displayed descriptions should be removed", ^{
            [presenter clearPresentedItems];
            [verify(view) clearReelDescriptions];
        });
    });
    
    describe(@"show reel description", ^{
        it(@"should show reel description", ^{
            RTReel *reel = [[RTReel alloc] initWithReelId:@(reelId)
                                                     name:@"something"
                                             audienceSize:@(4)
                                           numberOfVideos:@(3)];

            [presenter presentItem:reel];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showReelDescription:[captor capture]];
            
            RTReelDescription *description = [captor value];
            expect(description).toNot.beNil();
            
            expect(description.text).to.equal(@"something");
            expect(description.reelId).to.equal(@(reelId));
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