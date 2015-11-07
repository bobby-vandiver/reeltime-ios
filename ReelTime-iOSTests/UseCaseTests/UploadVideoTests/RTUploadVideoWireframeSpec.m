#import "RTTestCommon.h"

#import "RTUploadVideoWireframe.h"
#import "RTRecordVideoWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTUploadVideoViewController.h"
#import "RTUploadVideoViewControllerFactory.h"

SpecBegin(RTUploadVideoWireframe)

describe(@"upload video wireframe", ^{
    
    __block RTUploadVideoWireframe *wireframe;
    
    __block RTRecordVideoWireframe *recordVideoWireframe;
    __block RTApplicationWireframe *applicationWireframe;

    __block RTUploadVideoViewController *viewController;
    __block id<RTUploadVideoViewControllerFactory> viewControllerFactory;

    __block NSURL *videoUrl;
    __block NSURL *thumbnailUrl;
    
    beforeEach(^{
        recordVideoWireframe = mock([RTRecordVideoWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        viewController = mock([RTUploadVideoViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTUploadVideoViewControllerFactory));
        
        wireframe = [[RTUploadVideoWireframe alloc] initWithViewControllerFactory:viewControllerFactory
                                                             recordVideoWireframe:recordVideoWireframe
                                                             applicationWireframe:applicationWireframe];
        videoUrl = mock([NSURL class]);
        thumbnailUrl = mock([NSURL class]);
    });
    
    describe(@"presenting upload video interface", ^{
        beforeEach(^{
            [given([viewControllerFactory uploadVideoViewControllerForVideo:videoUrl thumbnail:thumbnailUrl])
             willReturn:viewController];
        });
        
        it(@"should create the view controller and navigate to it", ^{
            [wireframe presentUploadVideoInterfaceForVideo:videoUrl thumbnail:thumbnailUrl];

            [verify(viewControllerFactory) uploadVideoViewControllerForVideo:videoUrl thumbnail:thumbnailUrl];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting video camera interface", ^{
        it(@"should delegate to record video wireframe", ^{
            [wireframe presentVideoCameraInterface];
            [verify(recordVideoWireframe) presentVideoCameraInterface];
        });
    });
});

SpecEnd
