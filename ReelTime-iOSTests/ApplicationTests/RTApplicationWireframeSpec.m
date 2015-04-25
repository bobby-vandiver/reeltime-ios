#import "RTTestCommon.h"

#import "RTApplicationWireframe.h"
#import "RTApplicationTabBarController.h"

#import "RTApplicationWireframeContainer.h"
#import "RTLoginWireframe.h"

SpecBegin(RTApplicationWireframe)

describe(@"application wireframe", ^{
    
    __block RTApplicationWireframe *wireframe;

    __block RTApplicationTabBarController *tabBarController;
    __block RTApplicationWireframeContainer *wireframeContainer;
    
    __block RTLoginWireframe *loginWireframe;
    
    __block UIWindow *window;
    
    beforeEach(^{
        window = mock([UIWindow class]);
        tabBarController = mock([RTApplicationTabBarController class]);

        wireframeContainer = [[RTApplicationWireframeContainer alloc] init];

        loginWireframe = mock([RTLoginWireframe class]);
        wireframeContainer.loginWireframe = loginWireframe;
        
        wireframe = [[RTApplicationWireframe alloc]initWithWindow:window
                                                  tabBarController:tabBarController
                                                wireframeContainer:wireframeContainer];
    });
    
    describe(@"presenting initial screen", ^{
        it(@"should present the login interface", ^{
            [wireframe presentInitialScreen];
            [verify(loginWireframe) presentLoginInterface];
        });
    });
});

SpecEnd