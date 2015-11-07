#import "RTTestCommon.h"

#import "RTUploadVideoWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTUploadVideoViewController.h"
#import "RTUploadVideoViewControllerFactory.h"

SpecBegin(RTUploadVideoWireframe)

describe(@"upload video wireframe", ^{
    
    __block RTUploadVideoWireframe *wireframe;
    __block RTApplicationWireframe *applicationWireframe;

    __block RTUploadVideoViewController *viewController;
    __block id<RTUploadVideoViewControllerFactory> viewControllerFactory;
    
    beforeEach(^{
        applicationWireframe = mock([RTApplicationWireframe class]);
        viewController = mock([RTUploadVideoViewController class]);
        
        wireframe = [[RTUploadVideoWireframe alloc] initWithViewControllerFactory:viewControllerFactory
                                                             applicationWireframe:applicationWireframe];
    });
});

SpecEnd
