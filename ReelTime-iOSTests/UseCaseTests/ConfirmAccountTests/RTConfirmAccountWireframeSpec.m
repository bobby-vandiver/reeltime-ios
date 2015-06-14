#import "RTTestCommon.h"

#import "RTConfirmAccountWireframe.h"
#import "RTConfirmAccountViewController.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTConfirmAccountWireframe)

describe(@"confirm account wireframe", ^{
    
    __block RTConfirmAccountWireframe *wireframe;
    
    __block RTConfirmAccountViewController *viewController;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTConfirmAccountViewController class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTConfirmAccountWireframe alloc] initWithViewController:viewController
                                                         applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting account confirmation", ^{
        it(@"should push view controller onto navigation controller", ^{
            [wireframe presentConfirmAccountInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
});

SpecEnd
