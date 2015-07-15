#import "RTTestCommon.h"

#import "RTLogoutWireframe.h"

#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTLogoutWireframe)

describe(@"logout wireframe", ^{
    
    __block RTLogoutWireframe *wireframe;
    
    __block RTLoginWireframe *loginWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        loginWireframe = mock([RTLoginWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTLogoutWireframe alloc] initWithLoginWireframe:loginWireframe
                                                 applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting login interface", ^{
        it(@"should push delegate to login wireframe", ^{
            [wireframe presentLoginInterface];
            [verify(loginWireframe) presentLoginInterface];
        });
    });
});

SpecEnd
