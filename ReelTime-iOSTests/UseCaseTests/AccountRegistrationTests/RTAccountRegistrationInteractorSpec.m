#import "RTTestCommon.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationDataManager.h"
#import "RTLoginInteractor.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

SpecBegin(RTAccountRegistrationInteractor)

describe(@"account registration interactor", ^{
    
    __block RTAccountRegistrationInteractor *interactor;

    __block RTAccountRegistrationPresenter *presenter;
    __block RTAccountRegistrationDataManager *dataManager;
    
    __block RTLoginInteractor *loginInteractor;

    __block NSString *username = @"someone";
    __block NSString *password = @"secret";
    __block NSString *email = @"someone@test.com";
    __block NSString *displayName = @"Some One";
    __block NSString *clientName = @"iPhone";
    
    beforeEach(^{
        presenter = mock([RTAccountRegistrationPresenter class]);
        dataManager = mock([RTAccountRegistrationDataManager class]);

        loginInteractor = mock([RTLoginInteractor class]);
        
        interactor = [[RTAccountRegistrationInteractor alloc] initWithPresenter:presenter
                                                                    dataManager:dataManager
                                                                loginInteractor:loginInteractor];
    });
    
    describe(@"account registration requested", ^{
        
        xcontext(@"missing parameters", ^{
            // TODO
        });
        
        xcontext(@"invalid parameters", ^{
            // TODO
        });
        
        describe(@"when registration is successful", ^{
            __block RTClientCredentials *clientCredentials;
            
            beforeEach(^{
                clientCredentials = [[RTClientCredentials alloc] initWithClientId:@"foo"
                                                                     clientSecret:@"bar"];
            });
            
            it(@"should save client credentials and attempt to login user automatically", ^{
                [interactor registerAccountWithUsername:username
                                               password:password
                                   confirmationPassword:password
                                                  email:email
                                            displayName:displayName
                                             clientName:clientName];
                
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
    });
    
});

SpecEnd