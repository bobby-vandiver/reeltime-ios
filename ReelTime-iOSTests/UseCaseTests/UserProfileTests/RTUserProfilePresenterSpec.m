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
    
    describe(@"requesting audience members", ^{
        it(@"should present audience members for reel", ^{
            [presenter requestedAudienceMembersForReelId:@(reelId)];
            [verify(wireframe) presentAudienceMembersForReelId:@(reelId)];
        });
    });
    
    describe(@"requesting followers", ^{
        it(@"should present followers for user", ^{
            [presenter requestedFollowersForUsername:username];
            [verify(wireframe) presentFollowersForUsername:username];
        });
    });
    
    describe(@"requesting followees", ^{
        it(@"should present followees for user", ^{
            [presenter requestedFolloweesForUsername:username];
            [verify(wireframe) presentFolloweesForUsername:username];
        });
    });
});

SpecEnd