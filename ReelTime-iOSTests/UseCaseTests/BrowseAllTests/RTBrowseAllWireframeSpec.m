#import "RTTestCommon.h"

#import "RTBrowseAllWireframe.h"
#import "RTBrowseAllViewController.h"

#import "RTUserProfileWireframe.h"
#import "RTPlayVideoWireframe.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTBrowseAllWireframe)

describe(@"browse all wireframe", ^{
    
    __block RTBrowseAllWireframe *wireframe;
    __block RTBrowseAllViewController *viewController;
    
    __block RTUserProfileWireframe *userProfileWireframe;
    __block RTPlayVideoWireframe *playVideoWireframe;
    
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        userProfileWireframe = mock([RTUserProfileWireframe class]);
        playVideoWireframe = mock([RTPlayVideoWireframe class]);

        applicationWireframe = mock([RTApplicationWireframe class]);
        viewController = mock([RTBrowseAllViewController class]);
        
        wireframe = [[RTBrowseAllWireframe alloc] initWithViewController:viewController
                                                    userProfileWireframe:userProfileWireframe
                                                      playVideoWireframe:playVideoWireframe
                                                    applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting user", ^{
        it(@"should delegate to user profile wireframe", ^{
            [wireframe presentUserForUsername:username];
            [verify(userProfileWireframe) presentUserForUsername:username];
        });
    });
    
    describe(@"presenting video", ^{
        it(@"should delegate to play video wireframe", ^{
            [wireframe presentVideoForVideoId:@(videoId)];
            [verify(playVideoWireframe) presentVideoForVideoId:@(videoId)];
        });
    });
});

SpecEnd
