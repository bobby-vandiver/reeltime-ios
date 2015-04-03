#import "RTTestCommon.h"

#import "RTBrowseVideosPresenter.h"

#import "RTBrowseVideosView.h"
#import "RTPagedListInteractor.h"
#import "RTVideoWireframe.h"

#import "RTVideo.h"
#import "RTThumbnail.h"
#import "RTVideoDescription.h"

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
            [verify(view) clearVideoDescriptions];
        });
    });
    
    describe(@"show video description", ^{
        it(@"should show video message", ^{
            RTThumbnail *thumbnail = [[RTThumbnail alloc] initWithData:[NSData data]];
            RTVideo *video = [[RTVideo alloc] initWithVideoId:@(videoId)
                                                        title:@"some video"
                                                    thumbnail:thumbnail];
            
            [presenter presentItem:video];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showVideoDescription:[captor capture]];
            
            RTVideoDescription *description = [captor value];
            expect(description).toNot.beNil();
            
            expect(description.text).to.equal(@"some video");
            expect(description.videoId).to.equal(@(videoId));
            expect(description.thumbnail).to.equal(thumbnail);
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