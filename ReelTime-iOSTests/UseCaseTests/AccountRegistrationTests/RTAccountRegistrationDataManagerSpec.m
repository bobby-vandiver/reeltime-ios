#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

#import "RTAccountRegistrationError.h"
#import "RTServerErrors.h"

SpecBegin(RTAccountRegistrationDataManager)

describe(@"account registration data manager", ^{
    
    __block RTAccountRegistrationDataManager *dataManager;
    __block id<RTAccountRegistrationDataManagerDelegate> delegate;
    
    __block RTClient *client;
    __block RTClientCredentialsStore *clientCredentialsStore;
   
    __block MKTArgumentCaptor *errorCaptor;
    __block NSArray *capturedErrors;
    __block NSError *firstError;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTAccountRegistrationDataManagerDelegate));
        
        client = mock([RTClient class]);
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        
        dataManager = [[RTAccountRegistrationDataManager alloc] initWithDelegate:delegate
                                                                          client:client
                                                          clientCredentialsStore:clientCredentialsStore];
        
        errorCaptor = [[MKTArgumentCaptor alloc] init];
        capturedErrors = nil;
        firstError = nil;
    });
    
    describe(@"registering an account", ^{
        __block RTAccountRegistration *registration;
        __block BOOL callbackExecuted;
        
        void (^callback)(RTClientCredentials *) = ^(RTClientCredentials *clientCredentials) {
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            registration = [[RTAccountRegistration alloc] initWithUsername:username
                                                                  password:password
                                                      confirmationPassword:password
                                                                     email:email
                                                               displayName:displayName
                                                                clientName:clientName];
            
            callbackExecuted = NO;
            [dataManager registerAccount:registration callback:callback];
        });
        
        it(@"should pass client credentials to callback on success", ^{
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) registerAccount:registration
                                   success:[successCaptor capture]
                                    failure:anything()];

            expect(callbackExecuted).to.beFalsy();
            
            void (^successHandler)(RTClientCredentials *) = [successCaptor value];
            successHandler(nil);
            
            expect(callbackExecuted).to.beTruthy();
        });
        
        describe(@"mapping server errors to registration errors and notifying delegate of failure to register", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;
            
            beforeEach(^{
                MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];

                [verify(client) registerAccount:registration
                                        success:anything()
                                        failure:[failureCaptor capture]];
                
                [verifyCount(delegate, never()) registerAccountFailedWithErrors:anything()];
                ServerErrorsCallback failureHandler = [failureCaptor value];
                
                void (^errorCaptureBlock)(MKTArgumentCaptor *) = ^(MKTArgumentCaptor *errorCaptor) {
                    [verify(delegate) registerAccountFailedWithErrors:[errorCaptor capture]];
                    [verify(delegate) reset];
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTAccountRegistrationErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                             errorCaptureBlock:errorCaptureBlock];
            });
            
            afterEach(^{
                expect(callbackExecuted).to.beFalsy();
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"[username] is required":                                            @(RTAccountRegistrationErrorMissingUsername),
                                          @"[password] is required":                                            @(RTAccountRegistrationErrorMissingPassword),
                                          @"[email] is required":                                               @(RTAccountRegistrationErrorMissingEmail),
                                          @"[display_name] is required":                                        @(RTAccountRegistrationErrorMissingDisplayName),
                                          @"[client_name] is required":                                         @(RTAccountRegistrationErrorMissingClientName),
                                          @"[username] must be 2-15 alphanumeric characters long":              @(RTAccountRegistrationErrorInvalidUsername),
                                          @"[password] must be at least 6 characters long":                     @(RTAccountRegistrationErrorInvalidPassword),
                                          @"[email] is not a valid e-mail address":                             @(RTAccountRegistrationErrorInvalidEmail),
                                          @"[display_name] must be 2-20 alphanumeric or space characters long": @(RTAccountRegistrationErrorInvalidDisplayName),
                                          @"[username] is not available":                                       @(RTAccountRegistrationErrorUsernameIsUnavailable),
                                          @"[email] is not available":                                          @(RTAccountRegistrationErrorEmailIsUnavailable),
                                          @"Unable to register. Please try again.":                             @(RTAccountRegistrationErrorRegistrationServiceUnavailable)
                                          };
                
                [helper expectForServerMessageToErrorCodeMapping:mapping];
            });
        });
    });
    
    describe(@"saving client credentials", ^{
        __block RTClientCredentials *clientCredentials;
        __block BOOL callbackExecuted;
        
        void (^callback)() = ^{
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                                 clientSecret:clientSecret];
            callbackExecuted = NO;
            
        });
        
        afterEach(^{
            [[verify(clientCredentialsStore) withMatcher:anything() forArgument:2]
             storeClientCredentials:clientCredentials forUsername:username error:nil];
        });
        
        it(@"should store client credentials and execute callback", ^{
            [[given([clientCredentialsStore storeClientCredentials:clientCredentials forUsername:username error:nil])
              withMatcher:anything() forArgument:2]
             willReturnBool:YES];

            [dataManager saveClientCredentials:clientCredentials
                                   forUsername:username
                                      callback:callback];

            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should notify delegate when unable to store client credentials", ^{
            [[given([clientCredentialsStore storeClientCredentials:clientCredentials forUsername:username error:nil])
              withMatcher:anything() forArgument:2]
             willReturnBool:NO];
            
            [dataManager saveClientCredentials:clientCredentials
                                   forUsername:username
                                      callback:callback];
            
            expect(callbackExecuted).to.beFalsy();
            
            [verify(delegate) failedToSaveClientCredentials:clientCredentials forUsername:username];
        });
    });
});

SpecEnd