#import "RTTestCommon.h"

#import "RTRemoveAccountWireframe.h"
#import "RTRemoveAccountViewController.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTRemoveAccountWireframe)

describe(@"remove account wireframe", ^{
    
    __block RTRemoveAccountWireframe *wireframe;
    
    __block RTRemoveAccountViewController *viewController;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTRemoveAccountViewController class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTRemoveAccountWireframe alloc] initWithViewController:viewController
                                                        applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting account removal", ^{
        it(@"should push view controller onto navigation controller", ^{
            [wireframe presentRemoveAccountInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting post removal", ^{
        it(@"should navigate to the initial app screen", ^{
            [wireframe presentPostRemoveAccountInterface];
            [verify(applicationWireframe) presentInitialScreen];
        });
    });
});

SpecEnd
