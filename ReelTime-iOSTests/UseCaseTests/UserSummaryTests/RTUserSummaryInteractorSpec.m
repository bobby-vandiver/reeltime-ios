#import "RTTestCommon.h"

#import "RTUserSummaryInteractor.h"
#import "RTUserSummaryInteractorDelegate.h"
#import "RTUserSummaryDataManager.h"

#import "RTUserSummaryError.h"
#import "RTUser.h"

SpecBegin(RTUserSummaryInteractor)

describe(@"user summary interactor", ^{
    
    __block RTUserSummaryInteractor *interactor;
    
    __block id<RTUserSummaryInteractorDelegate> delegate;
    __block RTUserSummaryDataManager *dataManager;

    __block MKTArgumentCaptor *captor;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTUserSummaryInteractorDelegate));
        dataManager = mock([RTUserSummaryDataManager class]);
        
        interactor = [[RTUserSummaryInteractor alloc] initWithDelegate:delegate
                                                           dataManager:dataManager];

        captor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"get summary for username", ^{
        it(@"should pass user to delegate upon successful retrieval", ^{
            [interactor summaryForUsername:username];
            
            [verify(dataManager) fetchUserForUsername:username
                                    userFoundCallback:[captor capture]
                                 userNotFoundCallback:anything()];
            
            [verifyCount(delegate, never()) retrievedUser:anything()];

            RTUser *user = [[RTUser alloc] init];
            
            UserCallback callback = [captor value];
            callback(user);
            
            [verify(delegate) retrievedUser:user];
        });
        
        it(@"should notify delegate when user not found", ^{
            [interactor summaryForUsername:username];
            
            [verify(dataManager) fetchUserForUsername:username
                                    userFoundCallback:anything()
                                 userNotFoundCallback:[captor capture]];
            
            [verifyCount(delegate, never()) failedToRetrieveUserWithError:anything()];
            
            NoArgsCallback callback = [captor value];
            callback();
            
            [verify(delegate) failedToRetrieveUserWithError:[captor capture]];
            expect(captor.value).to.beError(RTUserSummaryErrorDomain, RTUserSummaryErrorUserNotFound);
        });
        
        context(@"invalid username", ^{
            afterEach(^{
                [verify(delegate) failedToRetrieveUserWithError:[captor capture]];
                expect(captor.value).to.beError(RTUserSummaryErrorDomain, RTUserSummaryErrorMissingUsername);
            });
        
            it(@"should fail if username is nil", ^{
                [interactor summaryForUsername:nil];
            });
            
            it(@"should fail if username is blank", ^{
                [interactor summaryForUsername:@""];
            });
        });
    });
});

SpecEnd