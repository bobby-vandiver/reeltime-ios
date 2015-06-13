#import "RTTestCommon.h"

#import "RTChangePasswordWireframe.h"
#import "RTChangePasswordViewController.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTChangePasswordWireframe)

describe(@"change password wireframe", ^{
    
    __block RTChangePasswordWireframe *wireframe;

    __block RTChangePasswordViewController *viewController;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTChangePasswordViewController class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTChangePasswordWireframe alloc] initWithViewController:viewController
                                                         applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting password change", ^{
        it(@"should push view controller onto navigation controller", ^{
            [wireframe presentChangePasswordInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
});

SpecEnd