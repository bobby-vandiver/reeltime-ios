#import "RTTestCommon.h"

#import "RTChangeDisplayNameWireframe.h"
#import "RTChangeDisplayNameViewController.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTChangeDisplayNameWireframe)

describe(@"change display name wireframe", ^{
    
    __block RTChangeDisplayNameWireframe *wireframe;

    __block RTChangeDisplayNameViewController *viewController;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTChangeDisplayNameViewController class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTChangeDisplayNameWireframe alloc] initWithViewController:viewController
                                                            applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting display name change", ^{
        it(@"should push view controller onto navigation controller", ^{
            [wireframe presentChangeDisplayNameInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
});

SpecEnd