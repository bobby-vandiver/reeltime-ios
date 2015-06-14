#import "RTConfirmAccountPresenter.h"

#import "RTConfirmAccountView.h"
#import "RTConfirmAccountInteractor.h"

#import "RTConfirmAccountError.h"
#import "RTConfirmAccountErrorCodeToErrorMessageMapping.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTLogging.h"

@interface RTConfirmAccountPresenter ()

@property id<RTConfirmAccountView> view;
@property RTConfirmAccountInteractor *interactor;
@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTConfirmAccountPresenter

- (instancetype)initWithView:(id<RTConfirmAccountView>)view
                  interactor:(RTConfirmAccountInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTConfirmAccountErrorCodeToErrorMessageMapping *mapping = [[RTConfirmAccountErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedConfirmationEmail {
    [self.interactor sendConfirmationEmail];
}

- (void)requestedConfirmationWithCode:(NSString *)code {
    [self.interactor confirmAccountWithCode:code];
}

- (void)confirmationEmailSent {
    [self.view showMessage:@"Please check your email for the confirmation code"];
}

- (void)confirmationEmailFailedWithErrors:(NSArray *)errors {
    [self.errorPresenter presentErrors:errors];
}

- (void)confirmAccountSucceeded {
    [self.view showMessage:@"Your account has been confirmed"];
}

- (void)confirmAccountFailedWithErrors:(NSArray *)errors {
    [self.errorPresenter presentErrors:errors];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    switch (code) {
        case RTConfirmAccountErrorEmailFailure:
            [self.view showErrorMessage:message];
            break;
            
        case RTConfirmAccountErrorMissingConfirmationCode:
            [self.view showValidationErrorMessage:message forField:RTConfirmAccountViewFieldConfirmationCode];
            break;
        
        case RTConfirmAccountErrorInvalidConfirmationCode:
            [self.view showErrorMessage:message];
            break;
            
        default:
            DDLogWarn(@"Unknown account confirmation error code: %ld", (long)code);
            break;
    }
}

@end
