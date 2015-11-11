#import "RTTestCommon.h"

#import "RTRecordVideoPresenter.h"
#import "RTRecordVideoWireframe.h"

SpecBegin(RTRecordVideoPresenter)

describe(@"record video presenter", ^{
    
    __block RTRecordVideoPresenter *presenter;
    __block RTRecordVideoWireframe *wireframe;

    __block NSURL *videoURL;
    
    beforeEach(^{
        wireframe = mock([RTRecordVideoWireframe class]);
        presenter = [[RTRecordVideoPresenter alloc] initWithWireframe:wireframe];
        
        videoURL = mock([NSURL class]);
    });
    
    describe(@"video recorded", ^{
        it(@"should present capture thumbnail interface", ^{
            [presenter recordedVideo:videoURL];
            [verify(wireframe) presentCaptureThumbnailInterfaceForVideo:videoURL];
        });
    });
});

SpecEnd
