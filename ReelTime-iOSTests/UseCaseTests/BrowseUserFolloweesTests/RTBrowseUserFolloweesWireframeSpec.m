#import "RTTestCommon.h"

#import "RTBrowseUserFolloweesWireframe.h"

#import "RTBrowseUserFolloweesViewController.h"
#import "RTBrowseUserFolloweesViewControllerFactory.h"

#import "RTUserProfileWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTBrowseUserFolloweesWireframe)

describe(@"browse user followees wireframe", ^{
    
    __block RTBrowseUserFolloweesWireframe *wireframe;
    
    __block id<RTBrowseUserFolloweesViewControllerFactory> viewControllerFactory;
    __block RTBrowseUserFolloweesViewController *viewController;
    
    __block RTUserProfileWireframe *userProfileWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTBrowseUserFolloweesViewController class]);
        viewControllerFactory = mockProtocol(@protocol(RTBrowseUserFolloweesViewControllerFactory));
        
        userProfileWireframe = mock([RTUserProfileWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTBrowseUserFolloweesWireframe alloc] initWithViewControllerFactory:viewControllerFactory
                                                                     userProfileWireframe:userProfileWireframe
                                                                     applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting followees for user", ^{
        it(@"should navigate to newly created view controller", ^{
            [given([viewControllerFactory browseUserFolloweesViewControllerForUsername:username]) willReturn:viewController];
            
            [wireframe presentFolloweesForUsername:username];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting followee", ^{
        it(@"should delegate to user profile wireframe", ^{
            [wireframe presentUserForUsername:username];
            [verify(userProfileWireframe) presentUserForUsername:username];
        });
    });
});

SpecEnd
