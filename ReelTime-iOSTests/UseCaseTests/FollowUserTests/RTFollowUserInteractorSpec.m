#import "RTTestCommon.h"

#import "RTFollowUserInteractor.h"

#import "RTFollowUserInteractorDelegate.h"
#import "RTFollowUserDataManager.h"

#import "RTFollowUserError.h"
#import "RTErrorFactory.h"

SpecBegin(RTFollowUserInteractor)

describe(@"follow user interactor", ^{
    
    __block RTFollowUserInteractor *interactor;
    
    __block id<RTFollowUserInteractorDelegate> delegate;
    __block RTFollowUserDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTFollowUserInteractorDelegate));
        dataManager = mock([RTFollowUserDataManager class]);
        
        interactor = [[RTFollowUserInteractor alloc] initWithDelegate:delegate
                                                          dataManager:dataManager];
    });
    
    describe(@"following user", ^{
        
        context(@"invalid username", ^{
            it(@"should treat invalid username as belonging to an unknown user", ^{
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];

                [interactor followUserWithUsername:nil];
                [verify(delegate) followUserFailedForUsername:nil withError:[captor capture]];
                
                expect(captor.value).to.beError(RTFollowUserErrorDomain, RTFollowUserErrorUserNotFound);
            });
        });
        
        context(@"valid username", ^{
            __block MKTArgumentCaptor *successCaptor;
            __block MKTArgumentCaptor *failureCaptor;
            
            beforeEach(^{
                successCaptor = [[MKTArgumentCaptor alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor followUserWithUsername:username];
                [verify(dataManager) followUserWithUsername:username
                                              followSuccess:[successCaptor capture]
                                              followFailure:[failureCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [verify(delegate) followUserSucceededForUsername:username];
            });
            
            it(@"should notify delegate of failure", ^{
                NSError *error = [RTErrorFactory followUserErrorWithCode:RTFollowUserErrorUserNotFound];
                
                ErrorCallback failureHandler = [failureCaptor value];
                failureHandler(error);
                
                [verify(delegate) followUserFailedForUsername:username withError:error];
            });
        });
    });
});

SpecEnd