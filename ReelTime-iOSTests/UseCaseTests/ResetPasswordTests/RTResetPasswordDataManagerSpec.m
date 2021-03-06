#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTResetPasswordDataManager.h"

#import "RTResetPasswordError.h"
#import "RTAPIClient.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

SpecBegin(RTResetPasswordDataManager)

describe(@"reset password data manager", ^{
    
    __block RTResetPasswordDataManager *dataManager;
    __block RTAPIClient *client;
    
    __block RTUserCredentials *userCredentials;
    __block RTClientCredentials *clientCredentials;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    __block MKTArgumentCaptor *userCredentialsCaptor;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);        
        dataManager = [[RTResetPasswordDataManager alloc] initWithClient:client];
        
        userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                             password:password];
        
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
                
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
        
        userCredentialsCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"requesting reset password email", ^{
        __block RTCallbackTestExpectation *sendEmail;
        __block RTCallbackTestExpectation *sendEmailFailed;
        
        beforeEach(^{
            sendEmail = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            sendEmailFailed = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            [dataManager submitRequestForResetPasswordEmailForUsername:username
                                                             emailSent:sendEmail.noArgsCallback
                                                           emailFailed:sendEmailFailed.argsCallback];
            
            [verify(client) sendResetPasswordEmailForUsername:username
                                                      success:[successCaptor capture]
                                                      failure:[failureCaptor capture]];
            
            [sendEmailFailed expectCallbackNotExecuted];
            ServerErrorsCallback failureHandler = [failureCaptor value];

            NSArray *(^errorRetrievalBlock)() = ^{
                return sendEmailFailed.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTResetPasswordErrorDomain
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
                                      @"Requested user was not found":
                                          @(RTResetPasswordErrorUnknownUser),
                                      @"Unable to send reset password email. Please try again.":
                                          @(RTResetPasswordErrorEmailFailure)
                                      };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [sendEmailFailed expectCallbackExecuted];
        });
    });
    
    describe(@"reset password", ^{
        __block RTCallbackTestExpectation *resetSuccess;
        __block RTCallbackTestExpectation *resetSuccessWithCredentials;
        __block RTCallbackTestExpectation *resetFailure;

        beforeEach(^{
            resetSuccess = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            resetSuccessWithCredentials = [RTCallbackTestExpectation argsCallbackTextExpectation];

            resetFailure = [RTCallbackTestExpectation argsCallbackTextExpectation];
        });
        
        void (^initTestHelper)() = ^{
            RTUserCredentials *capturedUserCredentials = [userCredentialsCaptor value];
            expect(capturedUserCredentials.username).to.equal(username);
            expect(capturedUserCredentials.password).to.equal(password);
            
            [resetFailure expectCallbackNotExecuted];
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            NSArray *(^errorRetrievalBlock)() = ^{
                return resetFailure.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTResetPasswordErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                       errorRetrievalBlock:errorRetrievalBlock];
        };
        
        void (^testServerErrorMappings)() = ^{
            NSDictionary *mapping = @{
                                      @"[username] is required":
                                          @(RTResetPasswordErrorMissingUsername),
                                      @"[new_password] is required":
                                          @(RTResetPasswordErrorMissingPassword),
                                      @"[new_password] must be at least 6 characters long":
                                          @(RTResetPasswordErrorInvalidPassword),
                                      @"[code] is required":
                                          @(RTResetPasswordErrorMissingResetCode),
                                      @"[code] is invalid":
                                          @(RTResetPasswordErrorInvalidResetCode),
                                      @"[client_name] is required":
                                          @(RTResetPasswordErrorMissingClientName),
                                      @"Requested user was not found":
                                          @(RTResetPasswordErrorUnknownUser),
                                      @"Invalid credentials":
                                          @(RTResetPasswordErrorInvalidClientCredentials),
                                      @"Forbidden request":
                                          @(RTResetPasswordErrorForbiddenClient)
                                      };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [resetFailure expectCallbackExecuted];
        };
        
        context(@"registered client", ^{
            beforeEach(^{
                [dataManager resetPasswordToNewPassword:password
                                            forUsername:username
                                      clientCredentials:clientCredentials
                                               withCode:resetCode
                                   passwordResetSuccess:resetSuccess.noArgsCallback
                                                failure:resetFailure.argsCallback];
                
                [verify(client) resetPasswordWithCode:resetCode
                                      userCredentials:[userCredentialsCaptor capture]
                                    clientCredentials:clientCredentials
                                              success:[successCaptor capture]
                                              failure:[failureCaptor capture]];
                
                initTestHelper();
            });
            
            it(@"should invoke callback on success", ^{
                NoArgsCallback successCallback = [successCaptor value];
                successCallback();
                [resetSuccess expectCallbackExecuted];
            });
            
            it(@"should map server errors to domain specific errors", ^{
                testServerErrorMappings();
            });
        });
        
        context(@"new client", ^{
            beforeEach(^{
                [dataManager resetPasswordToNewPassword:password
                                            forUsername:username
                                               withCode:resetCode
                        registerNewClientWithClientName:clientName
                                   passwordResetSuccess:resetSuccessWithCredentials.argsCallback
                                                failure:resetFailure.argsCallback];
                
                [verify(client) resetPasswordWithCode:resetCode
                                      userCredentials:[userCredentialsCaptor capture]
                                           clientName:clientName
                                              success:[successCaptor capture]
                                              failure:[failureCaptor capture]];
                
                initTestHelper();
            });
            
            it(@"should invoke callback on success", ^{
                ClientCredentialsCallback successCallback = [successCaptor value];
                successCallback(clientCredentials);

                [resetSuccessWithCredentials expectCallbackExecuted];
                expect(resetSuccessWithCredentials.callbackArguments).to.beAnInstanceOf([RTClientCredentials class]);
                
                RTClientCredentials *credentials = resetSuccessWithCredentials.callbackArguments;
                expect(credentials.clientId).to.equal(clientId);
                expect(credentials.clientSecret).to.equal(clientSecret);
            });
            
            it(@"should map server errors to domain specific errors", ^{
                testServerErrorMappings();
            });
        });
    });
});

SpecEnd