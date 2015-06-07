#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTRevokeClientDataManager.h"

#import "RTAPIClient.h"
#import "RTRevokeClientError.h"

SpecBegin(RTRevokeClientDataManager)

describe(@"revoke client data manager", ^{
    
    __block RTRevokeClientDataManager *dataManager;
    __block RTAPIClient *client;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTRevokeClientDataManager alloc] initWithClient:client];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"requesting client revocation", ^{
        __block RTCallbackTestExpectation *revokeSuccess;
        __block RTCallbackTestExpectation *revokeFailure;
        
        beforeEach(^{
            revokeSuccess = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            revokeFailure = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            [dataManager revokeClientWithClientId:clientId
                                revocationSuccees:revokeSuccess.noArgsCallback
                                          failure:revokeFailure.argsCallback];
            
            [verify(client) removeClientWithClientId:clientId
                                             success:[successCaptor capture]
                                             failure:[failureCaptor capture]];
            
            [revokeSuccess expectCallbackNotExecuted];
            [revokeFailure expectCallbackNotExecuted];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            NSArray *(^errorRetrievalBlock)() = ^{
                return revokeFailure.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTRevokeClientErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                       errorRetrievalBlock:errorRetrievalBlock];
        });
        
        it(@"should invoke callback on successful revocation", ^{
            NoArgsCallback successCallback = [successCaptor value];
            successCallback();
            [revokeSuccess expectCallbackExecuted];
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                      @"[client_id] is required":
                                          @(RTRevokeClientErrorMissingClientId)
                                      };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [revokeFailure expectCallbackExecuted];
        });
    });
});

SpecEnd