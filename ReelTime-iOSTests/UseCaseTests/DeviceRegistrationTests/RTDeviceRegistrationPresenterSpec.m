#import "RTTestCommon.h"

#import "RTDeviceRegistrationPresenter.h"
#import "RTDeviceRegistrationView.h"
#import "RTDeviceRegistrationInteractor.h"
#import "RTDeviceRegistrationWireframe.h"

#import "RTDeviceRegistrationError.h"
#import "RTErrorFactory.h"

SpecBegin(RTDeviceRegistrationPresenter)

describe(@"device registration presenter", ^{
    
    __block RTDeviceRegistrationPresenter *presenter;
    __block id<RTDeviceRegistrationView> view;

    __block RTDeviceRegistrationInteractor *interactor;
    __block RTDeviceRegistrationWireframe *wireframe;
    
    beforeEach(^{
        wireframe = mock([RTDeviceRegistrationWireframe class]);
        interactor = mock([RTDeviceRegistrationInteractor class]);
        
        view = mockProtocol(@protocol(RTDeviceRegistrationView));
        presenter = [[RTDeviceRegistrationPresenter alloc] initWithView:view
                                                             interactor:interactor
                                                              wireframe:wireframe];
    });
    
    describe(@"requesting device registration", ^{
        it(@"should instruct interactor to perform the registration", ^{
            [presenter requestedDeviceRegistrationWithClientName:clientName username:username password:password];
            [verify(interactor) registerDeviceWithClientName:clientName username:username password:password];
        });
    });

    describe(@"registration failure", ^{
        __block RTErrorPresentationChecker *errorChecker;
        __block RTFieldErrorPresentationChecker *fieldErrorChecker;

        ArrayCallback errorsCallback = ^(NSArray *errors) {
            [presenter deviceRegistrationFailedWithErrors:errors];
        };
 
        ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger code) {
            return [RTErrorFactory deviceRegistrationErrorWithCode:code];
        };
        
        beforeEach(^{
            errorChecker = [[RTErrorPresentationChecker alloc] initWithView:view
                                                             errorsCallback:errorsCallback
                                                       errorFactoryCallback:errorFactoryCallback];

            fieldErrorChecker = [[RTFieldErrorPresentationChecker alloc] initWithView:view
                                                                       errorsCallback:errorsCallback
                                                                 errorFactoryCallback:errorFactoryCallback];
        });
        
        it(@"should not inform view if error domain is incorrect", ^{
            NSError *error = [NSError errorWithDomain:NSInvalidArgumentException
                                                 code:0
                                             userInfo:nil];

            [presenter deviceRegistrationFailedWithErrors:@[error]];

            [verifyCount(view, never()) showErrorMessage:anything()];
            [[verifyCount(view, never()) withMatcher:anything() forArgument:1] showValidationErrorMessage:anything() forField:0];
        });
        
        it(@"should report missing username", ^{
            [fieldErrorChecker verifyErrorMessage:@"Username is required"
                              isShownForErrorCode:RTDeviceRegistrationErrorMissingUsername
                                            field:RTDeviceRegistrationViewFieldUsername];
        });
        
        it(@"should report missing password", ^{
            [fieldErrorChecker verifyErrorMessage:@"Password is required"
                              isShownForErrorCode:RTDeviceRegistrationErrorMissingPassword
                                            field:RTDeviceRegistrationViewFieldPassword];
        });
        
        it(@"should report missing client name", ^{
            [fieldErrorChecker verifyErrorMessage:@"Client name is required"
                              isShownForErrorCode:RTDeviceRegistrationErrorMissingClientName
                                            field:RTDeviceRegistrationViewFieldClientName];
        });
        
        it(@"should report all missing fields", ^{
            NSArray *errorCodes = @[
                                    @(RTDeviceRegistrationErrorMissingUsername),
                                    @(RTDeviceRegistrationErrorMissingPassword),
                                    @(RTDeviceRegistrationErrorMissingClientName)
                                    ];

            NSDictionary *mapping = @{
                                      @(RTDeviceRegistrationViewFieldUsername): @"Username is required",
                                      @(RTDeviceRegistrationViewFieldPassword): @"Password is required",
                                      @(RTDeviceRegistrationViewFieldClientName): @"Client name is required"
                                      };
            
            [fieldErrorChecker verifyMultipleErrorMessagesAreShownForErrorCodes:errorCodes withFieldMessageMapping:mapping];
        });
        
        it(@"should report invalid credentials", ^{
            [errorChecker verifyErrorMessage:@"Invalid username or password"
                         isShownForErrorCode:RTDeviceRegistrationErrorInvalidCredentials];
        });
        
        it(@"should report failure to store client credentials", ^{
            [errorChecker verifyErrorMessage:@"This device was registered but a problem occurred while completing the registration. "
                                             @"Please register under a different name or unregister the current device from a different device and try again."
                         isShownForErrorCode:RTDeviceRegistrationErrorUnableToStoreClientCredentials];
        });
        
        it(@"should report service unavailable", ^{
            [errorChecker verifyErrorMessage:@"Unable to register a device at this time. Please try again shortly."
                         isShownForErrorCode:RTDeviceRegistrationErrorServiceUnavailable];
        });
    });
    
    describe(@"routing to other modules", ^{
        it(@"should present login interface when registration is successful", ^{
            [presenter deviceRegistrationSucceeded];
            [verify(wireframe) presentLoginInterface];
        });
    });
});

SpecEnd