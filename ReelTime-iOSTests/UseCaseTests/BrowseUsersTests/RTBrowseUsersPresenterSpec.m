#import "RTTestCommon.h"

#import "RTBrowseUsersPresenter.h"

#import "RTBrowseUsersView.h"
#import "RTPagedListInteractor.h"
#import "RTUserWireframe.h"

#import "RTUser.h"
#import "RTUserDescription.h"

SpecBegin(RTBrowseUsersPresenter)

describe(@"browse users presenter", ^{
    
    __block RTBrowseUsersPresenter *presenter;
    
    __block id<RTBrowseUsersView> view;
    __block RTPagedListInteractor *interactor;
    __block id<RTUserWireframe> wireframe;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTBrowseUsersView));
        interactor = mock([RTPagedListInteractor class]);
        wireframe = mockProtocol(@protocol(RTUserWireframe));
        
        presenter = [[RTBrowseUsersPresenter alloc] initWithView:view
                                                      interactor:interactor
                                                       wireframe:wireframe];
    });
    
    describe(@"list reset", ^{
        it(@"should notify view that currently displayed messages should be removed", ^{
            [presenter clearPresentedItems];
            [verify(view) clearUserDescriptions];
        });
    });
    
    describe(@"show user message", ^{
        it(@"should show user message", ^{
            RTUser *user = [[RTUser alloc] initWithUsername:username
                                                displayName:displayName
                                          numberOfFollowers:@(1)
                                          numberOfFollowees:@(2)
                                         numberOfReelsOwned:@(3)
                                numberOfAudienceMemberships:@(4)
                                     currentUserIsFollowing:@(YES)];
            
            [presenter presentItem:user];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showUserDescription:[captor capture]];
            
            RTUserDescription *description = [captor value];
            expect(description).toNot.beNil();
            
            expect(description.username).to.equal(username);
            expect(description.displayName).to.equal(displayName);
            expect(description.numberOfFollowers).to.equal(@(1));
            expect(description.numberOfFollowees).to.equal(@(2));
            expect(description.numberOfReelsOwned).to.equal(@(3));
            expect(description.numberOfAudienceMemberships).to.equal(@(4));
        });
    });
    
    describe(@"requesting user details", ^{
        it(@"should present user", ^{
            [presenter requestedUserDetailsForUsername:username];
            [verify(wireframe) presentUserForUsername:username];
        });
    });
});

SpecEnd
