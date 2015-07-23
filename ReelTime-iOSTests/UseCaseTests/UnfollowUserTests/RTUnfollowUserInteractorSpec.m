#import "RTTestCommon.h"

#import "RTUnfollowUserInteractor.h"

#import "RTUnfollowUserInteractorDelegate.h"
#import "RTUnfollowUserDataManager.h"

#import "RTUnfollowUserError.h"
#import "RTErrorFactory.h"

SpecBegin(RTUnfollowUserInteractor)

describe(@"unfollow user interactor", ^{
    
    __block RTUnfollowUserInteractor *interactor;
    
    __block id<RTUnfollowUserInteractorDelegate> delegate;
    __block RTUnfollowUserDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTUnfollowUserInteractorDelegate));
        dataManager = mock([RTUnfollowUserDataManager class]);
        
        interactor = [[RTUnfollowUserInteractor alloc] initWithDelegate:delegate
                                                            dataManager:dataManager];
    });
    
    describe(@"unfollowing user", ^{
        
        context(@"invalid username", ^{
            it(@"should treat invalid username as belonging to an unknown user", ^{
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                
                [interactor unfollowUserWithUsername:nil];
                [verify(delegate) unfollowUserFailedForUsername:nil withError:[captor capture]];
                
                expect(captor.value).to.beError(RTUnfollowUserErrorDomain, RTUnfollowUserErrorUserNotFound);
            });
        });
        
        context(@"valid username", ^{
            __block MKTArgumentCaptor *successCaptor;
            __block MKTArgumentCaptor *failureCaptor;
            
            beforeEach(^{
                successCaptor = [[MKTArgumentCaptor alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor unfollowUserWithUsername:username];
                [verify(dataManager) unfollowUserWithUsername:username
                                              unfollowSuccess:[successCaptor capture]
                                              unfollowFailure:[failureCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [verify(delegate) unfollowUserSucceededForUsername:username];
            });
            
            it(@"should notify delegate of failure", ^{
                NSError *error = [RTErrorFactory unfollowUserErrorWithCode:RTUnfollowUserErrorUserNotFound];
                
                ErrorCallback failureHandler = [failureCaptor value];
                failureHandler(error);
                
                [verify(delegate) unfollowUserFailedForUsername:username withError:error];
            });
        });
    });
});

SpecEnd