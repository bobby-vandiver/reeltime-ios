#import "RTTestCommon.h"

#import "RTBrowseVideosPresenter.h"

#import "RTBrowseVideosView.h"
#import "RTPagedListInteractor.h"
#import "RTVideoWireframe.h"

#import "RTVideo.h"
#import "RTVideoMessage.h"

SpecBegin(RTBrowseVideosPresenter)

describe(@"browse videos presenter", ^{
    
    __block RTBrowseVideosPresenter *presenter;
    
    __block id<RTBrowseVideosView> view;
    __block RTPagedListInteractor *interactor;
    __block id<RTVideoWireframe> wireframe;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTBrowseVideosView));
        interactor = mock([RTPagedListInteractor class]);
        wireframe = mockProtocol(@protocol(RTVideoWireframe));
        
        presenter = [[RTBrowseVideosPresenter alloc] initWithView:view
                                                       interactor:interactor
                                                        wireframe:wireframe];
    });
    
    describe(@"list reset", ^{
        it(@"should notify view that currently displayed messages should be removed", ^{
            [presenter clearPresentedItems];
            [verify(view) clearVideoMessages];
        });
    });
    
    describe(@"show video message", ^{
        it(@"should show video message", ^{
            RTVideo *video = [[RTVideo alloc] initWithVideoId:@(videoId)
                                                        title:@"some video"];
            
            [presenter presentItem:video];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showVideoMessage:[captor capture]];
            
            RTVideoMessage *message = [captor value];
            expect(message).toNot.beNil();
            
            expect(message.text).to.equal(@"some video");
            expect(message.videoId).to.equal(@(videoId));
        });
    });
    
    describe(@"requesting video details", ^{
        it(@"should present video", ^{
            [presenter requestedVideoDetailsForVideoId:@(videoId)];
            [verify(wireframe) presentVideoForVideoId:@(videoId)];
        });
    });
});

SpecEnd