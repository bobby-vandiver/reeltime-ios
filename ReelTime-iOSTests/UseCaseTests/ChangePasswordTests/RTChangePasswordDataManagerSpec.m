#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTChangePasswordDataManager.h"
#import "RTAPIClient.h"

#import "RTChangePasswordError.h"

SpecBegin(RTChangePasswordDataManager)

describe(@"change password data manager", ^{
    
    __block RTChangePasswordDataManager *dataManager;
    __block RTAPIClient *client;

    __block RTCallbackTestExpectation *changed;
    __block RTCallbackTestExpectation *notChanged;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;

    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTChangePasswordDataManager alloc] initWithClient:client];

        changed = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
        notChanged = [RTCallbackTestExpectation argsCallbackTextExpectation];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"changing password", ^{
        beforeEach(^{
            [dataManager changePassword:password
                                changed:changed.noArgsCallback
                             notChanged:notChanged.argsCallback];

            [verify(client) changePassword:password
                                   success:[successCaptor capture]
                                   failure:[failureCaptor capture]];
            
            [changed expectCallbackNotExecuted];
            [notChanged expectCallbackNotExecuted];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            NSArray *(^errorRetrievalBlock)() = ^{
                return notChanged.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTChangePasswordErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                       errorRetrievalBlock:errorRetrievalBlock];
        });
        
        it(@"should invoke callback on successful change", ^{
            NoArgsCallback successHandler = [successCaptor value];
            successHandler();
            [changed expectCallbackExecuted];
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                      @"[new_password] is required":
                                          @(RTChangePasswordErrorMissingPassword),
                                      @"[new_password] must be at least 6 characters long":
                                          @(RTChangePasswordErrorInvalidPassword)
                                      };

            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [notChanged expectCallbackExecuted];
        });
    });
});

SpecEnd