#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTRemoveAccountDataManager.h"
#import "RTAPIClient.h"

#import "RTRemoveAccountError.h"

SpecBegin(RTRemoveAccountDataManager)

describe(@"remove account data manager", ^{
    
    __block RTRemoveAccountDataManager *dataManager;
    __block RTAPIClient *client;
    
    __block RTCallbackTestExpectation *removed;
    __block RTCallbackTestExpectation *notRemoved;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;

    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTRemoveAccountDataManager alloc] initWithClient:client];
        
        removed = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
        notRemoved = [RTCallbackTestExpectation argsCallbackTextExpectation];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"removing account", ^{
        beforeEach(^{
            [dataManager removeAccount:removed.noArgsCallback
                               failure:notRemoved.argsCallback];
            
            [verify(client) removeAccountWithSuccess:[successCaptor capture]
                                             failure:[failureCaptor capture]];
            
            [removed expectCallbackNotExecuted];
            [notRemoved expectCallbackNotExecuted];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            id (^errorRetrievalBlock)() = ^{
                return notRemoved.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTRemoveAccountErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                       errorRetrievalBlock:errorRetrievalBlock];
        });
        
        it(@"should invoke callback on succcessful removal", ^{
            NoArgsCallback successHandler = [successCaptor value];
            successHandler();
            [removed expectCallbackExecuted];
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                      @"Unauthorized operation requested":
                                          @(RTRemoveAccountErrorUnauthorized)
                                      };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [notRemoved expectCallbackExecuted];
        });
    });
});

SpecEnd

