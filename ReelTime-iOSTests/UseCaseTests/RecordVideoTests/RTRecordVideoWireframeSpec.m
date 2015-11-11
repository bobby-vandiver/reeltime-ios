#import "RTTestCommon.h"

#import "RTRecordVideoWireframe.h"
#import "RTRecordVideoViewController.h"

#import "RTCaptureThumbnailWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTRecordVideoWireframe)

describe(@"record video wireframe", ^{
    
    __block RTRecordVideoWireframe *wireframe;
    __block RTRecordVideoViewController *viewController;
    
    __block RTCaptureThumbnailWireframe *captureThumbnailWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTRecordVideoViewController class]);
        
        captureThumbnailWireframe = mock([RTCaptureThumbnailWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTRecordVideoWireframe alloc] initWithViewController:viewController
                                                 captureThumbnailWireframe:captureThumbnailWireframe
                                                      applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting video camera", ^{
        it(@"should navigate to video camera interface", ^{
            [wireframe presentVideoCameraInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting thumbnail capture", ^{
        __block NSURL *videoURL;
        
        beforeEach(^{
            videoURL = mock([NSURL class]);
        });
        
        it(@"should delegate to capture thumbnail wireframe", ^{
            [wireframe presentCaptureThumbnailInterfaceForVideo:videoURL];
            [verify(captureThumbnailWireframe) presentCaptureThumbnailInterfaceForVideo:videoURL];
        });
    });
});

SpecEnd
