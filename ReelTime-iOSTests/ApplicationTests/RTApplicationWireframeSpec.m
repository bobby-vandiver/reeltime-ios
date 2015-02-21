#import "RTTestCommon.h"

#import "RTApplicationWireframe.h"
#import "RTLoginWireframe.h"

SpecBegin(RTApplicationWireframe)

describe(@"application wireframe", ^{
    
    __block RTApplicationWireframe *wireframe;
    __block RTLoginWireframe *loginWireframe;
    
    __block UIWindow *window;
    
    beforeEach(^{
        window = mock([UIWindow class]);
        
        loginWireframe = mock([RTLoginWireframe class]);
        wireframe = [[RTApplicationWireframe alloc] initWithLoginWireframe:loginWireframe];
    });
    
    describe(@"presenting initial screen", ^{
        it(@"should present the login interface", ^{
            [wireframe presentInitialScreenFromWindow:window];
            [verify(loginWireframe) presentLoginInterfaceFromWindow:window];
        });
    });
});

SpecEnd