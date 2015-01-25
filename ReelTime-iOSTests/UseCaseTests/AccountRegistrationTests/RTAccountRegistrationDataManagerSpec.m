#import "RTTestCommon.h"

#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

#import "RTAccountRegistrationErrors.h"
#import "RTServerErrors.h"

#import "RTServerErrorsConverter.h"

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

        RTServerErrorsConverter *converter = [[RTServerErrorsConverter alloc] init];
        
        dataManager = [[RTAccountRegistrationDataManager alloc] initWithDelegate:delegate
                                                                          client:client
                                                           serverErrorsConverter:converter
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
            __block RTServerErrors *serverErrors;
            
            __block MKTArgumentCaptor *failureCaptor;
            __block void (^failureHandler)(RTServerErrors *);

            beforeEach(^{
                serverErrors = [[RTServerErrors alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [verify(client) registerAccount:registration
                                        success:anything()
                                        failure:[failureCaptor capture]];
                
                [verifyCount(delegate, never()) accountRegistrationDataOperationFailedWithErrors:anything()];
                
                failureHandler = [failureCaptor value];
            });
            
            afterEach(^{
                expect(callbackExecuted).to.beFalsy();
            });
            
            #define expectServerMessageMapping(msg, e, c) do {                                              \
                serverErrors.errors = [NSArray arrayWithObject:@msg];                                       \
                                                                                                            \
                failureHandler(serverErrors);                                                               \
                [verify(delegate) accountRegistrationDataOperationFailedWithErrors:[errorCaptor capture]];  \
                                                                                                            \
                capturedErrors = [errorCaptor value];                                                       \
                expect([capturedErrors count]).to.equal(c);                                                 \
                                                                                                            \
                if (c > 0) {                                                                                \
                    firstError = [capturedErrors objectAtIndex:0];                                          \
                    expect(firstError).to.beError(RTAccountRegistrationErrorDomain, e);                     \
                }                                                                                           \
            } while(0)
            
            it(@"should map username required to missing username", ^{
                expectServerMessageMapping("[username] is required",
                                           AccountRegistrationMissingUsername, 1);
            });
            
            it(@"should map password required to missing password", ^{
                expectServerMessageMapping("[password] is required",
                                           AccountRegistrationMissingPassword, 1);
            });
            
            it(@"should map email required to missing email", ^{
                expectServerMessageMapping("[email] is required",
                                           AccountRegistrationMissingEmail, 1);
            });
            
            it(@"should map display name required to missing display name", ^{
                expectServerMessageMapping("[display_name] is required",
                                           AccountRegistrationMissingDisplayName, 1);
            });
            
            it(@"should map client name required to missing client name", ^{
                expectServerMessageMapping("[client_name] is required",
                                           AccountRegistrationMissingClientName, 1);
            });
            
            it(@"should map invalid username", ^{
                expectServerMessageMapping("[username] must be 2-15 alphanumeric characters long",
                                           AccountRegistrationInvalidUsername, 1);
            });
            
            it(@"should map invalid password", ^{
                expectServerMessageMapping("[password] must be at least 6 characters long",
                                           AccountRegistrationInvalidPassword, 1);
            });
            
            it(@"should map invalid email", ^{
                expectServerMessageMapping("[email] is not a valid e-mail address",
                                           AccountRegistrationInvalidEmail, 1);
            });
            
            it(@"should map invalid display name", ^{
                expectServerMessageMapping("[display_name] must be 2-20 alphanumeric or space characters long",
                                           AccountRegistrationInvalidDisplayName, 1);
            });
            
            it(@"should map registration unavailable", ^{
                expectServerMessageMapping("Unable to register. Please try again.",
                                           AccountRegistrationRegistrationServiceUnavailable, 1);
            });
            
            it(@"should not map unexpected message", ^{
                expectServerMessageMapping("unknown registration error", 0, 0);
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
            
            [verify(delegate) unableToSaveClientCredentials:clientCredentials forUsername:username];
        });
    });
});

SpecEnd