#import "RTTestCommon.h"

#import "RTUserProfileWireframe.h"

#import "RTUserProfileViewController.h"
#import "RTUserProfileViewControllerFactory.h"

#import "RTAccountSettingsWireframe.h"
#import "RTBrowseAudienceMembersWireframe.h"

#import "RTBrowseUserFollowersWireframe.h"
#import "RTBrowseUserFolloweesWireframe.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTUserProfileWireframe)

describe(@"user profile wireframe", ^{
    
    __block RTUserProfileWireframe *wireframe;
    
    __block RTUserProfileViewController *viewController;
    __block id<RTUserProfileViewControllerFactory> viewControllerFactory;
    
    __block RTAccountSettingsWireframe *accountSettingsWireframe;
    __block RTBrowseAudienceMembersWireframe *browseAudienceMembersWireframe;
    
    __block RTBrowseUserFollowersWireframe *browseUserFollowersWireframe;
    __block RTBrowseUserFolloweesWireframe *browseUserFolloweesWireframe;
    
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTUserProfileViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTUserProfileViewControllerFactory));

        accountSettingsWireframe = mock([RTAccountSettingsWireframe class]);
        browseAudienceMembersWireframe = mock([RTBrowseAudienceMembersWireframe class]);
        
        browseUserFollowersWireframe = mock([RTBrowseUserFollowersWireframe class]);
        browseUserFolloweesWireframe = mock([RTBrowseUserFolloweesWireframe class]);

        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTUserProfileWireframe alloc] initWithUserProfileViewControllerFactory:viewControllerFactory
                                                                    accountSettingsWireframe:accountSettingsWireframe
                                                              browseAudienceMembersWireframe:browseAudienceMembersWireframe
                                                                browseUserFollowersWireframe:browseUserFollowersWireframe
                                                                browseUserFolloweesWireframe:browseUserFolloweesWireframe
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
    
    describe(@"presenting followers for user", ^{
        it(@"should delegate to browse user followers wireframe", ^{
            [wireframe presentFollowersForUsername:username];
            [verify(browseUserFollowersWireframe) presentFollowersForUsername:username];
        });
    });
    
    describe(@"presenting followees for user", ^{
        it(@"should delegate to browse user followees wireframe", ^{
            [wireframe presentFolloweesForUsername:username];
            [verify(browseUserFolloweesWireframe) presentFolloweesForUsername:username];
        });
    });
});

SpecEnd