#import "RTTestCommon.h"

#import "RTBrowseUsersPresenter.h"

#import "RTBrowseUsersView.h"
#import "RTPagedListInteractor.h"
#import "RTUserWireframe.h"

#import "RTUser.h"
#import "RTUserMessage.h"

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
            [verify(view) clearUserMessages];
        });
    });
    
    describe(@"show user message", ^{
        it(@"should show user message", ^{
            RTUser *user = [[RTUser alloc] initWithUsername:username
                                                displayName:displayName
                                          numberOfFollowers:@(1)
                                          numberOfFollowees:@(2)];
            
            [presenter presentItem:user];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showUserMessage:[captor capture]];
            
            RTUserMessage *message = [captor value];
            expect(message).toNot.beNil();
            
            expect(message.text).to.equal(displayName);
            expect(message.username).to.equal(username);
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
