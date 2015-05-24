#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordInteractorDelegate.h"
#import "RTChangePasswordDataManager.h"

#import "RTPasswordValidationMapping.h"

#import "RTRegexPattern.h"
#import "RTErrorFactory.h"

@interface RTChangePasswordInteractor ()

@property (weak) id<RTChangePasswordInteractorDelegate> delegate;
@property RTChangePasswordDataManager *dataManager;

@end

@implementation RTChangePasswordInteractor

- (instancetype)initWithDelegate:(id<RTChangePasswordInteractorDelegate>)delegate
                     dataManager:(RTChangePasswordDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)changePassword:(NSString *)password
  confirmationPassword:(NSString *)confirmationPassword {

    NSArray *errors;
    BOOL valid = [super validateWithErrors:&errors validationBlock:^(NSMutableArray *errorContainer) {
        RTPasswordValidationMapping *mapping = [self validationMapping];
        [self validatePassword:password confirmationPassword:confirmationPassword withMapping:mapping errors:errorContainer];
    }];
    
    if (valid) {
        [self.dataManager changePassword:password
                                 changed:[self changedCallback]
                              notChanged:[self notChangedCallback]];
    }
    else {
        [self.delegate changePasswordFailedWithErrors:errors];
    }
}

- (RTPasswordValidationMapping *)validationMapping {
    return [RTPasswordValidationMapping mappingWithErrorDomain:RTChangePasswordErrorDomain
                                      missingPasswordErrorCode:RTChangePasswordErrorMissingPassword
                                      invalidPasswordErrorCode:RTChangePasswordErrorInvalidPassword
                          missingConfirmationPasswordErrorCode:RTChangePasswordErrorMissingConfirmationPassword
                         confirmationPasswordMismatchErrorCode:RTChangePasswordErrorConfirmationPasswordDoesNotMatch];
}

- (NoArgsCallback)changedCallback {
    return ^{
        [self.delegate changePasswordSucceeded];
    };
}

- (ArrayCallback)notChangedCallback {
    return ^(NSArray *errors) {
        [self.delegate changePasswordFailedWithErrors:errors];
    };
}

@end
