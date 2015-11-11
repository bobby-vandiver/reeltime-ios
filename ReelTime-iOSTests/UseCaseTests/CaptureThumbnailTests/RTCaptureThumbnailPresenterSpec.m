#import "RTTestCommon.h"

#import "RTCaptureThumbnailPresenter.h"
#import "RTCaptureThumbnailWireframe.h"

SpecBegin(RTCaptureThumbnailPresenter)

describe(@"capture thumbnail presenter", ^{
    
    __block RTCaptureThumbnailPresenter *presenter;
    __block RTCaptureThumbnailWireframe *wireframe;

    __block NSURL *videoURL;
    __block NSURL *thumbnailURL;
    
    beforeEach(^{
        wireframe = mock([RTCaptureThumbnailWireframe class]);
        presenter = [[RTCaptureThumbnailPresenter alloc] initWithWireframe:wireframe];
        
        videoURL = mock([NSURL class]);
        thumbnailURL = mock([NSURL class]);
    });

    describe(@"captured thumbnail", ^{
        it(@"should route to the upload video interface", ^{
            [presenter capturedThumbnail:thumbnailURL forVideo:videoURL];
            [verify(wireframe) presentUploadVideoInterfaceForVideo:videoURL thumbnail:thumbnailURL];
        });
    });
});

SpecEnd
