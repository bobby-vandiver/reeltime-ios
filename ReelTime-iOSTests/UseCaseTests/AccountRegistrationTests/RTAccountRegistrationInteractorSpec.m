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
    
    __block RTAccountRegistrationValidator *validator;
    __block RTLoginInteractor *loginInteractor;
    
    __block RTAccountRegistration *accountRegistration;
    __block RTClientCredentials *clientCredentials;
    
    NSArray *(^createRegistrationErrorArray)(NSArray *codes) = ^NSArray *(NSArray *codes) {
        NSMutableArray *errors = [[NSMutableArray alloc] init];
        
        for (NSNumber *code in codes) {
            NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:[code integerValue]];
            [errors addObject:error];
        };
        
        return nil;
    };
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTAccountRegistrationInteractorDelegate));
        dataManager = mock([RTAccountRegistrationDataManager class]);

        loginInteractor = mock([RTLoginInteractor class]);
        
        validator = mock([RTAccountRegistrationValidator class]);
        
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
        beforeEach(^{
            [[given([validator validateAccountRegistration:accountRegistration errors:nil])
              withMatcher:anything() forArgument:1]
             willReturnBool:YES];
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

    describe(@"registration fails validation", ^{
        beforeEach(^{
            [[given([validator validateAccountRegistration:accountRegistration errors:nil])
              withMatcher:anything() forArgument:1]
             willReturnBool:NO];
        });
        
        it(@"should not attempt registration if the unable to validate parameters locally", ^{
            [interactor registerAccount:accountRegistration];
            [verify(delegate) registrationFailedWithValidationErrors:anything()];

            [verifyCount(dataManager, never()) saveClientCredentials:anything()
                                                         forUsername:anything()
                                                            callback:anything()];
        });
    });
    
    describe(@"registration failure", ^{
        it(@"should notify delegate of account creation but unable to register device", ^{
            [interactor failedToSaveClientCredentials:clientCredentials forUsername:username];
            
            MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) registrationWithAutoLoginFailedWithError:[errorCaptor capture]];
            
            NSError *error = [errorCaptor value];
            expect(error).to.beError(RTAccountRegistrationErrorDomain, AccountRegistrationUnableToAssociateClientWithDevice);
        });
        
        it(@"should filter registration errors and notify delegate", ^{
            NSArray *validationCodes = @[
                                         @(AccountRegistrationMissingUsername),
                                         @(AccountRegistrationMissingPassword),
                                         @(AccountRegistrationMissingConfirmationPassword),
                                         @(AccountRegistrationMissingEmail),
                                         @(AccountRegistrationMissingDisplayName),
                                         @(AccountRegistrationMissingClientName),
                                         
                                         @(AccountRegistrationInvalidUsername),
                                         @(AccountRegistrationInvalidPassword),
                                         @(AccountRegistrationInvalidEmail),
                                         @(AccountRegistrationInvalidDisplayName),

                                         @(AccountRegistrationConfirmationPasswordDoesNotMatch)
                                         ];
            
            NSArray *otherCodes = @[
                                    @(AccountRegistrationUsernameIsUnavailable),
                                    @(AccountRegistrationRegistrationServiceUnavailable)
                                    ];
            
            NSArray *validationErrors = createRegistrationErrorArray(validationCodes);
            NSArray *otherErrors = createRegistrationErrorArray(otherCodes);
            
            NSMutableArray *allRegistrationErrors = [[NSMutableArray alloc] init];

            [allRegistrationErrors addObjectsFromArray:validationErrors];
            [allRegistrationErrors addObjectsFromArray:otherErrors];
            
            [interactor registerAccountFailedWithErrors:allRegistrationErrors];
            
            MKTArgumentCaptor *validationErrorsCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) registrationFailedWithValidationErrors:[validationErrorsCaptor capture]];
            
            NSArray *capturedValidationErrors = [validationErrorsCaptor value];
            expect(capturedValidationErrors).to.equal(validationErrors);
            
            MKTArgumentCaptor *otherErrorsCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) registrationFailedWithErrors:[otherErrorsCaptor capture]];
            
            NSArray *capturedOtherErrors = [otherErrorsCaptor value];
            expect(capturedOtherErrors).to.equal(otherErrors);
        });
    });
});

SpecEnd