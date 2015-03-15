#import "RTTestCommon.h"

#import "RTApplicationWireframe.h"
#import "RTApplicationTabBarController.h"
#import "RTLoginWireframe.h"

SpecBegin(RTApplicationWireframe)

describe(@"application wireframe", ^{
    
    __block RTApplicationWireframe *wireframe;

    __block RTApplicationTabBarController *tabBarController;
    __block RTLoginWireframe *loginWireframe;
    
    __block UIWindow *window;
    
    beforeEach(^{
        window = mock([UIWindow class]);
        tabBarController = mock([RTApplicationTabBarController class]);
        loginWireframe = mock([RTLoginWireframe class]);
        
        wireframe = [[RTApplicationWireframe alloc] initWithWindow:window
                                                  tabBarController:tabBarController
                                                    loginWireframe:loginWireframe];
    });
    
    describe(@"presenting initial screen", ^{
        xit(@"should present the login interface", ^{
            [wireframe presentInitialScreen];
            [verify(loginWireframe) presentLoginInterfaceFromWindow:window];
        });
    });
});

SpecEnd