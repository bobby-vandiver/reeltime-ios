#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTResetPasswordDataManager.h"
#import "RTResetPasswordDataManagerDelegate.h"

#import "RTResetPasswordError.h"

#import "RTClient.h"
#import "RTClientCredentials.h"

SpecBegin(RTResetPasswordDataManager)

describe(@"reset password data manager", ^{
    
    __block RTResetPasswordDataManager *dataManager;
    __block id<RTResetPasswordDataManagerDelegate> delegate;

    __block RTClient *client;
    __block RTClientCredentials *clientCredentials;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    beforeEach(^{
        client = mock([RTClient class]);
        delegate = mockProtocol(@protocol(RTResetPasswordDataManagerDelegate));
        
        dataManager = [[RTResetPasswordDataManager alloc] initWithDelegate:delegate
                                                                    client:client];
        
        
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
        
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"requesting reset password email", ^{
        __block BOOL callbackExecuted;
        
        NoArgsCallback callback = ^{
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            callbackExecuted = NO;

            [dataManager submitRequestForResetPasswordEmailForUsername:username
                                                          withCallback:callback];
            
            [verify(client) sendResetPasswordEmailForUsername:username
                                                      success:[successCaptor capture]
                                                      failure:[failureCaptor capture]];
            
            [verifyCount(delegate, never()) sendResetEmailFailedWithErrors:anything()];
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            void (^errorCaptureBlock)(MKTArgumentCaptor *) = ^(MKTArgumentCaptor *errorCaptor) {
                [verify(delegate) sendResetEmailFailedWithErrors:[errorCaptor capture]];
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
});

SpecEnd