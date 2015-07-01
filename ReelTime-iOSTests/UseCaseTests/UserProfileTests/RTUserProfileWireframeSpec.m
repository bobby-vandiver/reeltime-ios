#import "RTTestCommon.h"

#import "RTUserProfileWireframe.h"

#import "RTUserProfileViewController.h"
#import "RTUserProfileViewControllerFactory.h"

#import "RTAccountSettingsWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTUserProfileWireframe)

describe(@"user profile wireframe", ^{
    
    __block RTUserProfileWireframe *wireframe;
    
    __block RTUserProfileViewController *viewController;
    __block id<RTUserProfileViewControllerFactory> viewControllerFactory;
    
    __block RTAccountSettingsWireframe *accountSettingsWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTUserProfileViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTUserProfileViewControllerFactory));

        accountSettingsWireframe = mock([RTAccountSettingsWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTUserProfileWireframe alloc] initWithUserProfileViewControllerFactory:viewControllerFactory
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