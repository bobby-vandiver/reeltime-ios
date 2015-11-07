#import "RTTestCommon.h"

#import "RTUploadVideoPresenter.h"

#import "RTUploadVideoView.h"
#import "RTUploadVideoInteractor.h"
#import "RTUploadVideoWireframe.h"

#import "RTUploadVideoError.h"
#import "RTErrorFactory.h"

SpecBegin(RTUploadVideoPresenter)

describe(@"upload video presenter", ^{
    
    __block RTUploadVideoPresenter *presenter;
    __block id<RTUploadVideoView> view;
    
    __block RTUploadVideoInteractor *interactor;
    __block RTUploadVideoWireframe *wireframe;

    __block NSURL *videoUrl;
    __block NSURL *thumbnailUrl;
    
    beforeEach(^{
        wireframe = mock([RTUploadVideoWireframe class]);
        interactor = mock([RTUploadVideoInteractor class]);
        
        view = mockProtocol(@protocol(RTUploadVideoView));
        
        presenter = [[RTUploadVideoPresenter alloc] initWithView:view
                                                      interactor:interactor
                                                       wireframe:wireframe];
        
        videoUrl = mock([NSURL class]);
        thumbnailUrl = mock([NSURL class]);
    });
    
    describe(@"requested video upload", ^{
        it(@"should pass parameters to interactor", ^{
            [presenter requestedUploadForVideo:videoUrl withThumbnail:thumbnailUrl videoTitle:videoTitle toReelWithName:reelName];
            [verify(interactor) uploadVideo:videoUrl thumbnail:thumbnailUrl withVideoTitle:videoTitle toReelWithName:reelName];
        });
    });
});

SpecEnd
