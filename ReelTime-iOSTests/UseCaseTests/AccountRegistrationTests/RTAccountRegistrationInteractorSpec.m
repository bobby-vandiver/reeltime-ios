#import "RTTestCommon.h"

#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationInteractorDelegate.h"

#import "RTAccountRegistrationDataManager.h"
#import "RTLoginInteractor.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"
#import "RTAccountRegistrationErrors.h"

SpecBegin(RTAccountRegistrationInteractor)

describe(@"account registration interactor", ^{
    
    __block RTAccountRegistrationInteractor *interactor;

    __block id<RTAccountRegistrationInteractorDelegate> delegate;
    __block RTAccountRegistrationDataManager *dataManager;
    
    __block RTLoginInteractor *loginInteractor;
    
    __block RTAccountRegistration *accountRegistration;
    
    NSString *const USERNAME_KEY = @"username";
    NSString *const PASSWORD_KEY = @"password";
    NSString *const CONFIRMATION_PASSWORD_KEY = @"confirmationPassword";
    NSString *const EMAIL_KEY = @"email";
    NSString *const DISPLAY_NAME_KEY = @"displayName";
    NSString *const CLIENT_NAME_KEY = @"clientName";
    
    void (^expectRegistrationFailureError)(RTAccountRegistrationErrors) = ^(RTAccountRegistrationErrors expectedErrorCode) {
        MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
        [verify(delegate) registrationFailedWithErrors:[errorCaptor capture]];
        
        NSArray *errors = [errorCaptor value];
        expect([errors count]).to.equal(1);
        expect([errors objectAtIndex:0]).to.beError(RTAccountRegistrationErrorDomain, expectedErrorCode);
    };

    void (^expectErrorForBadParameters)(NSDictionary *parameters, RTAccountRegistrationErrors expectedErrorCode) =
    ^(NSDictionary *parameters, RTAccountRegistrationErrors expectedErrorCode) {
        
        NSString *usernameParam = [parameters objectForKey:USERNAME_KEY];
        NSString *passwordParam = [parameters objectForKey:PASSWORD_KEY];
        NSString *confirmationParam = [parameters objectForKey:CONFIRMATION_PASSWORD_KEY];
        NSString *emailParam = [parameters objectForKey:EMAIL_KEY];
        NSString *displayNameParam = [parameters objectForKey:DISPLAY_NAME_KEY];
        NSString *clientNameParam = [parameters objectForKey:CLIENT_NAME_KEY];
        
        RTAccountRegistration *registration = [RTAccountRegistration alloc];
        registration = [registration initWithUsername:(usernameParam ? usernameParam : username)
                                             password:(passwordParam ? passwordParam : password)
                                 confirmationPassword:(confirmationParam ? confirmationParam : password)
                                                email:(emailParam ? emailParam : email)
                                          displayName:(displayNameParam ? displayNameParam : displayName)
                                           clientName:(clientNameParam ? clientNameParam : clientName)];
        
        [interactor registerAccount:registration];

        expectRegistrationFailureError(expectedErrorCode);
    };
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTAccountRegistrationInteractorDelegate));
        dataManager = mock([RTAccountRegistrationDataManager class]);

        loginInteractor = mock([RTLoginInteractor class]);
        
        interactor = [[RTAccountRegistrationInteractor alloc] initWithDelegate:delegate
                                                                   dataManager:dataManager
                                                               loginInteractor:loginInteractor];
        
        accountRegistration = [[RTAccountRegistration alloc] initWithUsername:username
                                                                     password:password
                                                         confirmationPassword:password
                                                                        email:email
                                                                  displayName:displayName
                                                                   clientName:clientName];
    });
    
    describe(@"account registration requested", ^{
        
        context(@"missing parameters", ^{
            NSString *const BLANK = @"";
            
            afterEach(^{
                [verifyCount(dataManager, never()) registerAccount:anything() callback:anything()];
            });
            
            it(@"blank username", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: BLANK}, AccountRegistrationMissingUsername);
            });
            
            it(@"blank password", ^{
                expectErrorForBadParameters(@{PASSWORD_KEY: BLANK}, AccountRegistrationMissingPassword);
            });
            
            it(@"blank confirmation password", ^{
                expectErrorForBadParameters(@{CONFIRMATION_PASSWORD_KEY: BLANK}, AccountRegistrationMissingConfirmationPassword);
            });
            
            it(@"blank email", ^{
                expectErrorForBadParameters(@{EMAIL_KEY: BLANK}, AccountRegistrationMissingEmail);
            });
            
            it(@"blank display name", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: BLANK}, AccountRegistrationMissingDisplayName);
            });
            
            it(@"blank client name", ^{
                expectErrorForBadParameters(@{CLIENT_NAME_KEY: BLANK}, AccountRegistrationMissingClientName);
            });
        });
        
        xcontext(@"invalid parameters", ^{
            // TODO
        });
        
        describe(@"when registration is successful", ^{
            __block RTClientCredentials *clientCredentials;
            
            beforeEach(^{
                clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                                     clientSecret:clientSecret];
            });
            
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
    });
    
});

SpecEnd