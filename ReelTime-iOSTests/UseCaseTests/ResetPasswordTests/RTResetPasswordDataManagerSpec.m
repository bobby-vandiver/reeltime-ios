#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTResetPasswordDataManager.h"
#import "RTResetPasswordDataManagerDelegate.h"

#import "RTResetPasswordError.h"
#import "RTClient.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

SpecBegin(RTResetPasswordDataManager)

describe(@"reset password data manager", ^{
    
    __block RTResetPasswordDataManager *dataManager;
    __block id<RTResetPasswordDataManagerDelegate> delegate;

    __block RTClient *client;
    
    __block RTUserCredentials *userCredentials;
    __block RTClientCredentials *clientCredentials;
    
    __block BOOL callbackExecuted;
    __block BOOL clientCredentialsCallbackExecuted;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    __block MKTArgumentCaptor *userCredentialsCaptor;

    NoArgsCallback callback = ^{
        callbackExecuted = YES;
    };
    
    ClientCredentialsCallback clientCredentialsCallback = ^(RTClientCredentials *credentials) {
        clientCredentialsCallbackExecuted = YES;
        expect(credentials.clientId).to.equal(clientId);
        expect(credentials.clientSecret).to.equal(clientSecret);
    };
    
    beforeEach(^{
        client = mock([RTClient class]);
        delegate = mockProtocol(@protocol(RTResetPasswordDataManagerDelegate));
        
        dataManager = [[RTResetPasswordDataManager alloc] initWithDelegate:delegate
                                                                    client:client];
        
        userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                             password:password];
        
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
                
        callbackExecuted = NO;
        clientCredentialsCallbackExecuted = NO;
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
        
        userCredentialsCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"requesting reset password email", ^{
        beforeEach(^{
            [dataManager submitRequestForResetPasswordEmailForUsername:username
                                                          withCallback:callback];
            
            [verify(client) sendResetPasswordEmailForUsername:username
                                                      success:[successCaptor capture]
                                                      failure:[failureCaptor capture]];
            
            [verifyCount(delegate, never()) submitRequestForResetPasswordEmailFailedWithErrors:anything()];
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            void (^errorCaptureBlock)(MKTArgumentCaptor *) = ^(MKTArgumentCaptor *errorCaptor) {
                [verify(delegate) submitRequestForResetPasswordEmailFailedWithErrors:[errorCaptor capture]];
                [verify(delegate) reset];
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTResetPasswordErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                         errorCaptureBlock:errorCaptureBlock];
        });
        
        it(@"should invoke callback on successful submission", ^{
            NoArgsCallback successCallback = [successCaptor value];
            successCallback();
            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                      @"Requested user was not found":
                                          @(RTResetPasswordErrorUnknownUser),
                                      @"Unable to send reset password email. Please try again.":
                                          @(RTResetPasswordErrorEmailFailure)
                                      };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
        });
    });
    
    describe(@"reset password", ^{
        void (^initTestHelper)() = ^{
            RTUserCredentials *capturedUserCredentials = [userCredentialsCaptor value];
            expect(capturedUserCredentials.username).to.equal(username);
            expect(capturedUserCredentials.password).to.equal(password);
            
            [verifyCount(delegate, never()) failedToResetPasswordWithErrors:anything()];
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            void (^errorCaptureBlock)(MKTArgumentCaptor *) = ^(MKTArgumentCaptor *errorCaptor) {
                [verify(delegate) failedToResetPasswordWithErrors:[errorCaptor capture]];
                [verify(delegate) reset];
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTResetPasswordErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                         errorCaptureBlock:errorCaptureBlock];
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
        };
        
        context(@"registered client", ^{
            beforeEach(^{
                [dataManager resetPasswordToNewPassword:password
                                            forUsername:username
                                      clientCredentials:clientCredentials
                                               withCode:resetCode
                                               callback:callback];
                
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
                expect(callbackExecuted).to.beTruthy();
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
                                               callback:clientCredentialsCallback];

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
                expect(clientCredentialsCallbackExecuted).to.beTruthy();
            });
            
            it(@"should map server errors to domain specific errors", ^{
                testServerErrorMappings();
            });
        });
    });
});

SpecEnd