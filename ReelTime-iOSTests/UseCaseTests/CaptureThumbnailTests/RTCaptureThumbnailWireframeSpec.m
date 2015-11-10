#import "RTTestCommon.h"

#import "RTCaptureThumbnailWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTCaptureThumbnailViewController.h" 
#import "RTCaptureThumbnailViewControllerFactory.h"

SpecBegin(RTCaptureThumbnailWireframe)

describe(@"capture thumbnail wireframe", ^{
    
    __block RTCaptureThumbnailWireframe *wireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    __block RTCaptureThumbnailViewController *viewController;
    __block id<RTCaptureThumbnailViewControllerFactory> viewControllerFactory;
    
    beforeEach(^{
        viewController = mock([RTCaptureThumbnailViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTCaptureThumbnailViewControllerFactory));
        
        applicationWireframe = mock([RTApplicationWireframe class]);
        wireframe = [[RTCaptureThumbnailWireframe alloc] initWithViewControllerFactory:viewControllerFactory
                                                                  applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting capture thumbnail interface", ^{
        __block NSURL *videoURL;
        
        beforeEach(^{
            videoURL = mock([NSURL class]);
            [given([viewControllerFactory captureThumbnailViewControllerForVideo:videoURL]) willReturn:viewController];
        });
        
        it(@"should create view controller and navigate to it", ^{
            [wireframe presentCaptureThumbnailInterfaceForVideo:videoURL];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
});

SpecEnd
