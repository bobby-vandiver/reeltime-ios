#import "RTTestCommon.h"

#import "RTRecordVideoWireframe.h"
#import "RTRecordVideoViewController.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTRecordVideoWireframe)

describe(@"record video wireframe", ^{
    
    __block RTRecordVideoWireframe *wireframe;

    __block RTRecordVideoViewController *viewController;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTRecordVideoViewController class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTRecordVideoWireframe alloc] initWithViewController:viewController
                                                      applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting video camera", ^{
        it(@"should navigate to video camera interface", ^{
            [wireframe presentVideoCameraInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
});

SpecEnd
