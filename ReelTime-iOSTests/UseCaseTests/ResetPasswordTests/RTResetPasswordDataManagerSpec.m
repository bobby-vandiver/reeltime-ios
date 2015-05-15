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
    __block NSString *resetCode;
    
    __block RTUserCredentials *userCredentials;
    __block RTClientCredentials *clientCredentials;
    
    __block BOOL callbackExecuted;
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    __block MKTArgumentCaptor *userCredentialsCaptor;

    NoArgsCallback callback = ^{
        callbackExecuted = YES;
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
        
        resetCode = @"reset";
        callbackExecuted = NO;
        
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
            
            [verifyCount(delegate, never()) sendResetPasswordEmailFailedWithErrors:anything()];
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            void (^errorCaptureBlock)(MKTArgumentCaptor *) = ^(MKTArgumentCaptor *errorCaptor) {
                [verify(delegate) sendResetPasswordEmailFailedWithErrors:[errorCaptor capture]];
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
    
    describe(@"reset password for registered client", ^{
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
            
            RTUserCredentials *capturedUserCredentials = [userCredentialsCaptor value];
            expect(capturedUserCredentials.username).to.equal(username);
            expect(capturedUserCredentials.password).to.equal(password);
            
            [verifyCount(delegate, never()) resetPasswordFailedWithErrors:anything()];
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            void (^errorCaptureBlock)(MKTArgumentCaptor *) = ^(MKTArgumentCaptor *errorCaptor) {
                [verify(delegate) resetPasswordFailedWithErrors:[errorCaptor capture]];
                [verify(delegate) reset];
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTResetPasswordErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                         errorCaptureBlock:errorCaptureBlock];
        });
        
        it(@"should invoke callback on success", ^{
            NoArgsCallback successCallback = [successCaptor value];
            successCallback();
            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                      // TODO: Add expected mappings
                                      };

            [helper expectForServerMessageToErrorCodeMapping:mapping];
        });
    });
});

SpecEnd