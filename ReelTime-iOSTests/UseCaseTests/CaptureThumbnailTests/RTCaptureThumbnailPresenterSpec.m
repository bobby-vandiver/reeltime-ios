#import "RTTestCommon.h"

#import "RTCaptureThumbnailPresenter.h"
#import "RTCaptureThumbnailWireframe.h"

SpecBegin(RTCaptureThumbnailPresenter)

describe(@"capture thumbnail presenter", ^{
    
    __block RTCaptureThumbnailPresenter *presenter;
    __block RTCaptureThumbnailWireframe *wireframe;

    __block NSURL *thumbnailURL;
    
    beforeEach(^{
        wireframe = mock([RTCaptureThumbnailWireframe class]);
        presenter = [[RTCaptureThumbnailPresenter alloc] initWithWireframe:wireframe];
        
        thumbnailURL = mock([NSURL class]);
    });

    describe(@"captured thumbnail", ^{
        it(@"should route to the upload video interface", ^{
            [presenter capturedThumbnail:thumbnailURL];
        });
    });
});

SpecEnd
