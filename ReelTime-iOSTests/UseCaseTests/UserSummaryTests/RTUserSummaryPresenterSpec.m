#import "RTTestCommon.h"

#import "RTUserSummaryPresenter.h"
#import "RTUserSummaryView.h"
#import "RTUserSummaryInteractor.h"

#import "RTUser.h"
#import "RTUserDescription.h"

#import "RTUserSummaryError.h"
#import "RTErrorFactory.h"

SpecBegin(RTUserSummaryPresenter)

describe(@"user summary presenter", ^{
    
    __block RTUserSummaryPresenter *presenter;
    
    __block id<RTUserSummaryView> view;
    __block RTUserSummaryInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTUserSummaryView));
        interactor = mock([RTUserSummaryInteractor class]);
        
        presenter = [[RTUserSummaryPresenter alloc] initWithView:view
                                                      interactor:interactor];
    });
    
    describe(@"when summary is requested", ^{
        it(@"should pass username to interactor", ^{
            [presenter requestedSummaryForUsername:username];
            [verify(interactor) summaryForUsername:username];
        });
    });
    
    describe(@"when summary is retrieved", ^{
        it(@"should show a description", ^{
            RTUser *user = [[RTUser alloc] initWithUsername:username
                                                displayName:displayName
                                          numberOfFollowers:@(1)
                                          numberOfFollowees:@(2)
                                         numberOfReelsOwned:@(3)
                                numberOfAudienceMemberships:@(4)
                                     currentUserIsFollowing:@(YES)];
            
            [presenter retrievedUser:user];

            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showUserDescription:[captor capture]];
            
            RTUserDescription *description = captor.value;
            
            expect(description.username).to.equal(username);
            expect(description.displayName).to.equal(displayName);
            expect(description.numberOfFollowers).to.equal(@(1));
            expect(description.numberOfFollowees).to.equal(@(2));
            expect(description.numberOfReelsOwned).to.equal(@(3));
            expect(description.numberOfAudienceMemberships).to.equal(@(4));
        });
    });
    
    describe(@"summary failures", ^{
        it(@"should show message when requested user was not found", ^{
            NSError *error = [RTErrorFactory userSummaryErrorWithCode:RTUserSummaryErrorUserNotFound];

            [presenter failedToRetrieveUserWithError:error];
            [verify(view) showUserNotFoundMessage:@"The requested user could not be found at this time"];
        });

        it(@"should not inform view for missing username", ^{
            NSError *error = [RTErrorFactory userSummaryErrorWithCode:RTUserSummaryErrorMissingUsername];

            [presenter failedToRetrieveUserWithError:error];
            [verifyCount(view, never()) showUserNotFoundMessage:anything()];
        });
        
        it(@"should not inform view for unknown error", ^{
            NSError *error = [NSError errorWithDomain:NSInvalidArgumentException
                                                 code:1234
                                             userInfo:nil];
            
            [presenter failedToRetrieveUserWithError:error];
            [verifyCount(view, never()) showUserNotFoundMessage:anything()];
        });
    });
});

SpecEnd
