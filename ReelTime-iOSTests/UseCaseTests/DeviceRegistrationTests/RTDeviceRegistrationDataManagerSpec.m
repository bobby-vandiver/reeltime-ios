#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTDeviceRegistrationDataManager.h"
#import "RTDeviceRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTServerErrorsConverter.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

#import "RTServerErrors.h"
#import "RTDeviceRegistrationError.h"

SpecBegin(RTDeviceRegistrationDataManager)

describe(@"device registration data manager", ^{
    
    __block RTDeviceRegistrationDataManager *dataManager;
    __block id<RTDeviceRegistrationDataManagerDelegate> delegate;
    
    __block RTClient *client;
    __block RTClientCredentialsStore *clientCredentialsStore;
    
    __block RTUserCredentials *userCredentials;
    __block RTClientCredentials *clientCredentials;
    
    beforeEach(^{
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        client = mock([RTClient class]);
        
        delegate = mockProtocol(@protocol(RTDeviceRegistrationDataManagerDelegate));
        dataManager = [[RTDeviceRegistrationDataManager alloc] initWithDelegate:delegate
                                                                         client:client
                                                         clientCredentialsStore:clientCredentialsStore];
        
        userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                             password:password];

        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
    });
    
    describe(@"fetching client credentials for new device", ^{
        __block BOOL callbackExecuted;
        
        void (^callback)(RTClientCredentials *) = ^(RTClientCredentials *credentials) {
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            callbackExecuted = NO;

            [dataManager fetchClientCredentialsForClientName:clientName
                                         withUserCredentials:userCredentials
                                                    callback:callback];
        });

        it(@"should invoke callback upon successful registration", ^{
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) registerClientWithClientName:clientName
                                         userCredentials:userCredentials
                                                 success:[successCaptor capture]
                                                 failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            ClientCredentialsCallback successHandler = [successCaptor value];
            successHandler(nil);
            
            expect(callbackExecuted).to.beTruthy();
        });
        
        describe(@"mapping server errors to registration errors and notifying delegate of failure to register", ^{
            __block MKTArgumentCaptor *failureCaptor;
            __block ServerErrorsCallback failureHandler;
            
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;
            
            beforeEach(^{
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [verify(client) registerClientWithClientName:clientName
                                             userCredentials:userCredentials
                                                     success:anything()
                                                     failure:[failureCaptor capture]];

                [verifyCount(delegate, never()) deviceRegistrationDataOperationFailedWithErrors:anything()];
                failureHandler = [failureCaptor value];
                
                void (^errorCaptureBlock)(MKTArgumentCaptor *) = ^(MKTArgumentCaptor *errorCaptor) {
                    [verify(delegate) deviceRegistrationDataOperationFailedWithErrors:[errorCaptor capture]];
                    [verify(delegate) reset];
                };

                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTDeviceRegistrationErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                             errorCaptureBlock:errorCaptureBlock];
            });
            
            afterEach(^{
                expect(callbackExecuted).to.beFalsy();
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"[username] is required":    @(RTDeviceRegistrationErrorMissingUsername),
                                          @"[password] is required":    @(RTDeviceRegistrationErrorMissingPassword),
                                          @"[client_name] is required": @(RTDeviceRegistrationErrorMissingClientName),
                                          @"Invalid credentials":       @(RTDeviceRegistrationErrorInvalidCredentials)
                                          };
                [helper expectForServerMessageToErrorCodeMapping:mapping];
            });
        });
    });
    
    describe(@"store client credentials", ^{
        __block BOOL callbackExecuted;
        
        void (^callback)() = ^{
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            callbackExecuted = NO;
        });
        
        it(@"should execute callback on successful storage", ^{
            [[given([clientCredentialsStore storeClientCredentials:clientCredentials forUsername:username error:nil])
              withMatcher:anything() forArgument:2] willReturnBool:YES];
            
            [dataManager storeClientCredentials:clientCredentials
                                    forUsername:username
                                       callback:callback];
            
            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should notify delegate of storage error", ^{
            [[given([clientCredentialsStore storeClientCredentials:clientCredentials forUsername:username error:nil])
              withMatcher:anything() forArgument:2] willReturnBool:NO];
            
            [dataManager storeClientCredentials:clientCredentials
                                    forUsername:username
                                       callback:callback];
            
            expect(callbackExecuted).to.beFalsy();
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];

            [verify(delegate) deviceRegistrationDataOperationFailedWithErrors:[captor capture]];
            
            NSArray *errors = [captor value];
            expect(errors).to.haveACountOf(1);
            
            expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorUnableToStoreClientCredentials);
        });
    });
});

SpecEnd