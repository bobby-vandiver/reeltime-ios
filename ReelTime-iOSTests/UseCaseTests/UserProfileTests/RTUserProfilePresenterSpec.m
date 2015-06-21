#import "RTTestCommon.h"

#import "RTUserProfilePresenter.h"
#import "RTUserProfileWireframe.h"  

SpecBegin(RTUserProfilePresenter)

describe(@"user profile presenter", ^{
    
    __block RTUserProfilePresenter *presenter;
    __block RTUserProfileWireframe *wireframe;
    
    beforeEach(^{
        wireframe = mock([RTUserProfileWireframe class]);
        presenter = [[RTUserProfilePresenter alloc] initWithWireframe:wireframe];
    });
    
    describe(@"requesting account settings", ^{
        it(@"should present account settings interface", ^{
            [presenter requestedAccountSettings];
            [verify(wireframe) presentAccountSettingsInterface];
        });
    });
});

SpecEnd