#import "RTTestCommon.h"

#import "RTUserProfileWireframe.h"

#import "RTUserProfileViewController.h"
#import "RTUserProfileViewControllerFactory.h"

#import "RTAccountSettingsWireframe.h"
#import "RTBrowseAudienceMembersWireframe.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTUserProfileWireframe)

describe(@"user profile wireframe", ^{
    
    __block RTUserProfileWireframe *wireframe;
    
    __block RTUserProfileViewController *viewController;
    __block id<RTUserProfileViewControllerFactory> viewControllerFactory;
    
    __block RTAccountSettingsWireframe *accountSettingsWireframe;
    __block RTBrowseAudienceMembersWireframe *browseAudienceMembersWireframe;
    
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTUserProfileViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTUserProfileViewControllerFactory));

        accountSettingsWireframe = mock([RTAccountSettingsWireframe class]);
        browseAudienceMembersWireframe = mock([RTBrowseAudienceMembersWireframe class]);
        
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTUserProfileWireframe alloc] initWithUserProfileViewControllerFactory:viewControllerFactory
                                                                    accountSettingsWireframe:accountSettingsWireframe
                                                              browseAudienceMembersWireframe:browseAudienceMembersWireframe
                                                                        applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting account settings interface", ^{
        it(@"should delegate to account setting wireframe", ^{
            [wireframe presentAccountSettingsInterface];
            [verify(accountSettingsWireframe) presentAccountSettingsInterface];
        });
    });
    
    describe(@"presenting audience members for reel", ^{
        it(@"should delegate to browse audience members wireframe", ^{
            [wireframe presentAudienceMembersForReelId:@(reelId)];
            [verify(browseAudienceMembersWireframe) presentAudienceMembersForReelId:@(reelId)];
        });
    });
});

SpecEnd