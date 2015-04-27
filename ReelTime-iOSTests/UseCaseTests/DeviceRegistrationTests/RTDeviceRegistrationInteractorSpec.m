#import "RTTestCommon.h"

#import "RTDeviceRegistrationInteractor.h"
#import "RTDeviceRegistrationInteractorDelegate.h"
#import "RTDeviceRegistrationDataManager.h"

#import "RTDeviceRegistrationError.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

#import "RTErrorFactory.h"

SpecBegin(RTDeviceRegistrationInteractor)

describe(@"device registration interactor", ^{
    
    __block RTDeviceRegistrationInteractor *interactor;

    __block id<RTDeviceRegistrationInteractorDelegate> delegate;
    __block RTDeviceRegistrationDataManager *dataManager;
    
    beforeEach(^{
        dataManager = mock([RTDeviceRegistrationDataManager class]);
        delegate = mockProtocol(@protocol(RTDeviceRegistrationInteractorDelegate));
        
        interactor = [[RTDeviceRegistrationInteractor alloc] initWithDelegate:delegate
                                                                  dataManager:dataManager];
    });
    
    describe(@"device registration requested", ^{
        
        context(@"missing parameters", ^{
            __block MKTArgumentCaptor *captor;
            
            beforeEach(^{
                captor = [[MKTArgumentCaptor alloc] init];
            });
            
            it(@"invalid client name", ^{
                [interactor registerDeviceWithClientName:BLANK username:username password:password];
                [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
                
                NSArray *errors = [captor value];
                expect(errors).to.haveACountOf(1);
                expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingClientName);
            });
            
            it(@"invalid username", ^{
                [interactor registerDeviceWithClientName:clientName username:BLANK password:password];
                [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
                
                NSArray *errors = [captor value];
                expect(errors).to.haveACountOf(1);
                expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingUsername);
            });
            
            it(@"invalid password", ^{
                [interactor registerDeviceWithClientName:clientName username:username password:BLANK];
                [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
                
                NSArray *errors = [captor value];
                expect(errors).to.haveACountOf(1);
                expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingPassword);
            });
            
            it(@"invalid client name, username and password", ^{
                [interactor registerDeviceWithClientName:BLANK username:BLANK password:BLANK];
                [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
                
                NSArray *errors = [captor value];
                expect(errors).to.haveACountOf(3);
                
                expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingClientName);
                expect(errors[1]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingUsername);
                expect(errors[2]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingPassword);
            });
        });
        
        context(@"successful registration", ^{
            it(@"should store client credentials and notify delegate on successful registration", ^{
                MKTArgumentCaptor *userCredentialsCaptor = [[MKTArgumentCaptor alloc] init];
                MKTArgumentCaptor *clientCredentialsCallbackCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor registerDeviceWithClientName:clientName username:username password:password];
                [verify(dataManager) fetchClientCredentialsForClientName:clientName
                                                     withUserCredentials:[userCredentialsCaptor capture]
                                                                callback:[clientCredentialsCallbackCaptor capture]];
                
                RTUserCredentials *userCredentials = [userCredentialsCaptor value];
                expect(userCredentials.username).to.equal(username);
                expect(userCredentials.password).to.equal(password);
                
                RTClientCredentials *clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                                                          clientSecret:clientSecret];
                
                void (^clientCredentialsHandler)(RTClientCredentials *) = [clientCredentialsCallbackCaptor value];
                clientCredentialsHandler(clientCredentials);
                
                MKTArgumentCaptor *storeClientCredentialsCallbackCaptor = [[MKTArgumentCaptor alloc] init];
                
                [verify(dataManager) storeClientCredentials:clientCredentials
                                                forUsername:username
                                                   callback:[storeClientCredentialsCallbackCaptor capture]];
                
                [verifyCount(delegate, never()) deviceRegistrationSucceeded];
                
                void (^finalCallback)() = [storeClientCredentialsCallbackCaptor value];
                finalCallback();
                
                [verify(delegate) deviceRegistrationSucceeded];
            });
        });
    });
    
    describe(@"data operation failures", ^{
        it(@"should bubble error up to delegate", ^{
            NSError *error = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorInvalidCredentials];
            [interactor deviceRegistrationDataOperationFailedWithErrors:@[error]];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
            
            NSArray *capturedErrors = [captor value];
            expect(capturedErrors).to.haveACountOf(1);
            expect(capturedErrors[0]).to.equal(error);
        });
    });
});

SpecEnd