#import "RTTestCommon.h"

#import "RTBrowseAudienceMembersWireframe.h"

#import "RTBrowseAudienceMembersViewController.h"
#import "RTBrowseAudienceMembersViewControllerFactory.h"

#import "RTUserProfileWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTBrowseAudienceMembersWireframe)

describe(@"browse audience members wireframe", ^{
    
    __block RTBrowseAudienceMembersWireframe *wireframe;

    __block id<RTBrowseAudienceMembersViewControllerFactory> viewControllerFactory;
    __block RTBrowseAudienceMembersViewController *viewController;
    
    __block RTUserProfileWireframe *userProfileWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTBrowseAudienceMembersViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTBrowseAudienceMembersViewControllerFactory));
        
        userProfileWireframe = mock([RTUserProfileWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTBrowseAudienceMembersWireframe alloc] initWithViewControllerFactory:viewControllerFactory
                                                                       userProfileWireframe:userProfileWireframe
                                                                       applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting audience members for reel", ^{
        it(@"should navigate to newly created view controller", ^{
            [given([viewControllerFactory browseAudienceMembersViewControllerForReelId:@(reelId)]) willReturn:viewController];

            [wireframe presentAudienceMembersForReelId:@(reelId)];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting audience member", ^{
        it(@"should delegate to user profile wireframe", ^{
            [wireframe presentUserForUsername:username];
            [verify(userProfileWireframe) presentUserForUsername:username];
        });
    });
});

SpecEnd