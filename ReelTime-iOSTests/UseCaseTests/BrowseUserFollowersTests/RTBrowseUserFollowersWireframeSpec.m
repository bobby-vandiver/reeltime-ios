#import "RTTestCommon.h"

#import "RTBrowseUserFollowersWireframe.h"

#import "RTBrowseUserFollowersViewController.h"
#import "RTBrowseUserFollowersViewControllerFactory.h"

#import "RTUserProfileWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTBrowseUserFollowersWireframe)

describe(@"browse user followers wireframe", ^{
    
    __block RTBrowseUserFollowersWireframe *wireframe;
    
    __block id<RTBrowseUserFollowersViewControllerFactory> viewControllerFactory;
    __block RTBrowseUserFollowersViewController *viewController;
    
    __block RTUserProfileWireframe *userProfileWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTBrowseUserFollowersViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTBrowseUserFollowersViewControllerFactory));
        
        userProfileWireframe = mock([RTUserProfileWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTBrowseUserFollowersWireframe alloc] initWithViewControllerFactory:viewControllerFactory
                                                                     userProfileWireframe:userProfileWireframe
                                                                     applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting followers for user", ^{
        it(@"should navigate to newly created view controller", ^{
            [given([viewControllerFactory browseUserFollowersViewControllerForUsername:username]) willReturn:viewController];
            
            [wireframe presentFollowersForUsername:username];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting follower", ^{
        it(@"should delegate to user profile wireframe", ^{
            [wireframe presentUserForUsername:username];
            [verify(userProfileWireframe) presentUserForUsername:username];
        });
    });
});

SpecEnd
