#import "RTTestCommon.h"

#import "RTUserProfileWireframe.h"
#import "RTUserProfileViewController.h"

#import "RTAccountSettingsWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTUserProfileWireframe)

describe(@"user profile wireframe", ^{
    
    __block RTUserProfileWireframe *wireframe;
    __block RTUserProfileViewController *viewController;
    
    __block RTAccountSettingsWireframe *accountSettingsWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTUserProfileViewController class]);

        accountSettingsWireframe = mock([RTAccountSettingsWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTUserProfileWireframe alloc] initWithViewController:viewController
                                                  accountSettingsWireframe:accountSettingsWireframe
                                                      applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting account settings interface", ^{
        it(@"should delegate to account setting wireframe", ^{
            [wireframe presentAccountSettingsInterface];
            [verify(accountSettingsWireframe) presentAccountSettingsInterface];
        });
    });
});

SpecEnd