#import "RTTestCommon.h"

#import "RTCaptureThumbnailWireframe.h"
#import "RTUploadVideoWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTCaptureThumbnailViewController.h" 
#import "RTCaptureThumbnailViewControllerFactory.h"

SpecBegin(RTCaptureThumbnailWireframe)

describe(@"capture thumbnail wireframe", ^{
    
    __block RTCaptureThumbnailWireframe *wireframe;

    __block RTUploadVideoWireframe *uploadVideoWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    __block RTCaptureThumbnailViewController *viewController;
    __block id<RTCaptureThumbnailViewControllerFactory> viewControllerFactory;
    
    __block NSURL *videoURL;
    __block NSURL *thumbnailURL;
    
    beforeEach(^{
        viewController = mock([RTCaptureThumbnailViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTCaptureThumbnailViewControllerFactory));
    
        uploadVideoWireframe = mock([RTUploadVideoWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTCaptureThumbnailWireframe alloc] initWithViewControllerFactory:viewControllerFactory
                                                                  uploadVideoWireframe:uploadVideoWireframe
                                                                  applicationWireframe:applicationWireframe];

        videoURL = mock([NSURL class]);
        thumbnailURL = mock([NSURL class]);
    });
    
    describe(@"presenting capture thumbnail interface", ^{
        beforeEach(^{
            [given([viewControllerFactory captureThumbnailViewControllerForVideo:videoURL]) willReturn:viewController];
        });
        
        it(@"should create view controller and navigate to it", ^{
            [wireframe presentCaptureThumbnailInterfaceForVideo:videoURL];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting upload video interface", ^{
        it(@"should delegate to upload video wireframe", ^{
            [wireframe presentUploadVideoInterfaceForVideo:videoURL thumbnail:thumbnailURL];
            [verify(uploadVideoWireframe) presentUploadVideoInterfaceForVideo:videoURL thumbnail:thumbnailURL];
        });
    });
});

SpecEnd
