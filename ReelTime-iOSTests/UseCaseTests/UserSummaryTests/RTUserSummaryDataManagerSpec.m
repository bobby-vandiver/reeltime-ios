#import "RTTestCommon.h"

#import "RTUserSummaryDataManager.h"
#import "RTClient.h"

SpecBegin(RTUserSummaryDataManager)

describe(@"user summary data manager", ^{
    
    __block RTUserSummaryDataManager *dataManager;
    __block RTClient *client;
    
    beforeEach(^{
        client = mock([RTClient class]);
        dataManager = [[RTUserSummaryDataManager alloc] initWithClient:client];
    });
    
    describe(@"fetching user for username", ^{
        __block RTCallbackTestExpectation *userFound;
        __block RTCallbackTestExpectation *userNotFound;
        
        beforeEach(^{
            userFound = [RTCallbackTestExpectationFactory userCallback];
            userNotFound = [RTCallbackTestExpectationFactory noArgsCallback];

            [dataManager fetchUserForUsername:username
                                    userFound:userFound.callback
                                 userNotFound:userNotFound.callback];
        });
        
        it(@"should pass user to callback on success", ^{
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) userForUsername:username
                                    success:[successCaptor capture]
                                    failure:anything()];
            
            [userFound expectCallbackNotExecuted];
            
            UserCallback successHandler = [successCaptor value];
            successHandler(nil);
            
            [userFound expectCallbackExecuted];
        });
        
        it(@"should inform delegate when the user was not found", ^{
            MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) userForUsername:username
                                    success:anything()
                                    failure:[failureCaptor capture]];
            
            [userNotFound expectCallbackNotExecuted];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            failureHandler(nil);
            
            [userNotFound expectCallbackExecuted];
        });
    });
});

SpecEnd