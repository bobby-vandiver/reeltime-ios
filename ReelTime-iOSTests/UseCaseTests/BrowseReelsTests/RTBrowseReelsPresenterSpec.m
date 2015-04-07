#import "RTTestCommon.h"

#import "RTBrowseReelsPresenter.h"

#import "RTBrowseReelsView.h"
#import "RTPagedListInteractor.h"
#import "RTReelWireframe.h"

#import "RTReel.h"
#import "RTUser.h"

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
            RTUser *owner = [[RTUser alloc] initWithUsername:username
                                                 displayName:displayName
                                           numberOfFollowers:@(1)
                                           numberOfFollowees:@(2)];
            
            RTReel *reel = [[RTReel alloc] initWithReelId:@(reelId)
                                                     name:@"something"
                                             audienceSize:@(4)
                                           numberOfVideos:@(3)
                                                    owner:owner];

            [presenter presentItem:reel];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showReelDescription:[captor capture]];
            
            RTReelDescription *description = [captor value];
            expect(description).toNot.beNil();
            
            expect(description.name).to.equal(@"something");
            expect(description.reelId).to.equal(@(reelId));
            expect(description.ownerUsername).to.equal(username);
        });
    });
    
    describe(@"requesting reel details", ^{
        it(@"should present reel", ^{
            [presenter requestedReelDetailsForReelId:@(reelId) ownerUsername:username];
            [verify(wireframe) presentReelForReelId:@(reelId) ownerUsername:username];
        });
    });
});

SpecEnd