#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTConfirmAccountDataManager.h"

#import "RTConfirmAccountError.h"
#import "RTAPIClient.h"

SpecBegin(RTConfirmAccountDataManager)

describe(@"confirm account data manager", ^{
    
    __block RTConfirmAccountDataManager *dataManager;
    __block RTAPIClient *client;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTConfirmAccountDataManager alloc] initWithClient:client];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"requesting confirmation email", ^{
        __block RTCallbackTestExpectation *sendEmail;
        __block RTCallbackTestExpectation *sendEmailFailed;
        
        beforeEach(^{
            sendEmail = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            sendEmailFailed = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            [dataManager submitRequestForConfirmationEmailWithEmailSent:sendEmail.noArgsCallback
                                                            emailFailed:sendEmailFailed.argsCallback];
            
            [verify(client) sendAccountConfirmationEmailWithSuccess:[successCaptor capture]
                                                            failure:[failureCaptor capture]];
            
            [sendEmail expectCallbackNotExecuted];
            [sendEmailFailed expectCallbackNotExecuted];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            NSArray *(^errorRetrievalBlock)() = ^{
                return sendEmailFailed.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTConfirmAccountErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                       errorRetrievalBlock:errorRetrievalBlock];
        });
        
        it(@"should invoke callback on successful submission", ^{
            NoArgsCallback successCallback = [successCaptor value];
            successCallback();
            [sendEmail expectCallbackExecuted];
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                      @"Unable to send account confirmation email. Please try again.":
                                          @(RTConfirmAccountErrorEmailFailure)
                                      };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [sendEmailFailed expectCallbackExecuted];
        });
    });
    
    describe(@"confirm account", ^{
        __block RTCallbackTestExpectation *confirmationSuccess;
        __block RTCallbackTestExpectation *confirmationFailure;
        
        beforeEach(^{
            confirmationSuccess = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            confirmationFailure = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            [dataManager confirmAccountWithCode:confirmationCode
                            confirmationSuccess:confirmationSuccess.noArgsCallback
                                        failure:confirmationFailure.argsCallback];
            
            [verify(client) confirmAccountWithCode:confirmationCode
                                           success:[successCaptor capture]
                                           failure:[failureCaptor capture]];
            
            [confirmationSuccess expectCallbackNotExecuted];
            [confirmationFailure expectCallbackNotExecuted];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            NSArray *(^errorRetrievalBlock)() = ^{
                return confirmationFailure.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTConfirmAccountErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                       errorRetrievalBlock:errorRetrievalBlock];
        });
        
        it(@"should invoke callback on success", ^{
            NoArgsCallback successCallback = [successCaptor value];
            successCallback();
            [confirmationSuccess expectCallbackExecuted];
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                      @"[code] is required":
                                          @(RTConfirmAccountErrorMissingConfirmationCode),
                                      @"[code] is invalid":
                                          @(RTConfirmAccountErrorInvalidConfirmationCode)
                                      };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [confirmationFailure expectCallbackExecuted];
        });
    });
});

SpecEnd