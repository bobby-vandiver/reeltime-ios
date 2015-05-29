#import "RTConfirmAccountInteractor.h"
#import "RTConfirmAccountInteractorDelegate.h"
#import "RTConfirmAccountDataManager.h"

#import "RTConfirmAccountError.h"
#import "RTErrorFactory.h"

@interface RTConfirmAccountInteractor ()

@property id<RTConfirmAccountInteractorDelegate> delegate;
@property RTConfirmAccountDataManager *dataManager;

@end

@implementation RTConfirmAccountInteractor

- (instancetype)initWithDelegate:(id<RTConfirmAccountInteractorDelegate>)delegate
                     dataManager:(RTConfirmAccountDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)sendConfirmationEmail {
    [self.dataManager submitRequestForConfirmationEmailWithEmailSent:[self emailSentCallback]
                                                         emailFailed:[self emailFailedCallback]];
}

- (NoArgsCallback)emailSentCallback {
    return ^{
        [self.delegate confirmationEmailSent];
    };
}

- (ArrayCallback)emailFailedCallback {
    return ^(NSArray *errors) {
        [self.delegate confirmationEmailFailedWithErrors:errors];
    };
}

- (void)confirmAccountWithCode:(NSString *)code {
    if (code.length == 0) {
        NSError *error = [RTErrorFactory confirmAccountErrorWithCode:RTConfirmAccountErrorMissingConfirmationCode];
        [self.delegate confirmAccountFailedWithErrors:@[error]];
    }
    else {
        [self.dataManager confirmAccountWithCode:code
                             confirmationSuccess:[self confirmationSuccessCallback]
                                         failure:[self confirmationFailureCallback]];
    }
}

- (NoArgsCallback)confirmationSuccessCallback {
    return ^{
        [self.delegate confirmAccountSucceeded];
    };
}

- (ArrayCallback)confirmationFailureCallback {
    return ^(NSArray *errors) {
        [self.delegate confirmAccountFailedWithErrors:errors];
    };
}

@end
