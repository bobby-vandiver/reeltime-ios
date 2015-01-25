#import "RTTestCommon.h"

#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationInteractorDelegate.h"

#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationValidator.h"
#import "RTLoginInteractor.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"
#import "RTAccountRegistrationErrors.h"

#import "RTErrorFactory.h"

SpecBegin(RTAccountRegistrationInteractor)

describe(@"account registration interactor", ^{
    
    __block RTAccountRegistrationInteractor *interactor;

    __block id<RTAccountRegistrationInteractorDelegate> delegate;
    __block RTAccountRegistrationDataManager *dataManager;
    
    __block RTLoginInteractor *loginInteractor;
    
    __block RTAccountRegistration *accountRegistration;
    __block RTClientCredentials *clientCredentials;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTAccountRegistrationInteractorDelegate));
        dataManager = mock([RTAccountRegistrationDataManager class]);

        loginInteractor = mock([RTLoginInteractor class]);
        
        RTAccountRegistrationValidator *validator = [[RTAccountRegistrationValidator alloc] init];
        
        interactor = [[RTAccountRegistrationInteractor alloc] initWithDelegate:delegate
                                                                   dataManager:dataManager
                                                                     validator:validator
                                                               loginInteractor:loginInteractor];
        
        accountRegistration = [[RTAccountRegistration alloc] initWithUsername:username
                                                                     password:password
                                                         confirmationPassword:password
                                                                        email:email
                                                                  displayName:displayName
                                                                   clientName:clientName];

        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
    });
    
    describe(@"successful registration", ^{
        it(@"should save client credentials and attempt to login user automatically", ^{
            [interactor registerAccount:accountRegistration];
            
            MKTArgumentCaptor *registrationCaptor = [[MKTArgumentCaptor alloc] init];
            MKTArgumentCaptor *callbackCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(dataManager) registerAccount:[registrationCaptor capture]
                                        callback:[callbackCaptor capture]];
            
            RTAccountRegistration *registrationArg = [registrationCaptor value];
            expect(registrationArg.username).to.equal(username);
            expect(registrationArg.password).to.equal(password);
            expect(registrationArg.email).to.equal(email);
            expect(registrationArg.displayName).to.equal(displayName);
            expect(registrationArg.clientName).to.equal(clientName);
            
            [verifyCount(dataManager, never()) saveClientCredentials:clientCredentials
                                                         forUsername:username
                                                            callback:anything()];
            
            void (^callback)(RTClientCredentials *generatedCredentials) = [callbackCaptor value];
            callback(clientCredentials);
            
            MKTArgumentCaptor *nestedCallbackCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(dataManager) saveClientCredentials:clientCredentials
                                           forUsername:username
                                              callback:[nestedCallbackCaptor capture]];
            
            [verifyCount(loginInteractor, never()) loginWithUsername:username password:password];
            
            void (^nestedCallback)() = [nestedCallbackCaptor value];
            nestedCallback();
            
            [verify(loginInteractor) loginWithUsername:username password:password];
        });
    });
    
    describe(@"registration failure", ^{
        it(@"should pass registration errors on to delegate", ^{
            NSArray *errors = @[[RTErrorFactory accountRegistrationErrorWithCode:AccountRegistrationInvalidUsername]];
            [interactor registerAccountFailedWithErrors:errors];
            [verify(delegate) registrationFailedWithErrors:errors];
        });
        
        it(@"should notify delegate of account creation but unable to register device", ^{
            [interactor failedToSaveClientCredentials:clientCredentials forUsername:username];
            
            MKTArgumentCaptor *errorsCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) registrationFailedWithErrors:[errorsCaptor capture]];
            
            NSArray *errors = [errorsCaptor value];
            expect([errors count]).to.equal(1);
            
            NSError *error = [errors objectAtIndex:0];
            expect(error).to.beError(RTAccountRegistrationErrorDomain, AccountRegistrationUnableToAssociateClientWithDevice);
        });
    });
});

SpecEnd