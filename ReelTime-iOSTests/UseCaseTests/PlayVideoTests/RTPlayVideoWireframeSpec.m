#import "RTTestCommon.h"

#import "RTPlayVideoWireframe.h"

#import "RTPlayVideoViewController.h"
#import "RTPlayVideoViewControllerFactory.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTPlayVideoWireframe)

describe(@"play video wireframe", ^{
    
    __block RTPlayVideoWireframe *wireframe;
    
    __block RTPlayVideoViewController *viewController;
    __block id<RTPlayVideoViewControllerFactory> viewControllerFactory;
    
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTPlayVideoViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTPlayVideoViewControllerFactory));
        
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTPlayVideoWireframe alloc] initWithViewControllerFactory:viewControllerFactory
                                                           applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting video", ^{
        it(@"should create video specific view controller and navigate to it", ^{
            [given([viewControllerFactory playVideoViewControllerForVideoId:@(videoId)]) willReturn:viewController];
            [wireframe presentVideoForVideoId:@(videoId)];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
});

SpecEnd
