#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordInteractorDelegate.h"
#import "RTChangePasswordDataManager.h"

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
        [self validatePassword:password confirmationPassword:confirmationPassword errors:errorContainer];
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

- (void)validatePassword:(NSString *)password
    confirmationPassword:(NSString *)confirmationPassword
                  errors:(NSMutableArray *)errors {
    if ([password length] == 0) {
        [self addErrorCode:RTChangePasswordErrorMissingPassword toErrors:errors];
    }
    else if ([password length] < PASSWORD_MINIMUM_LENGTH) {
        [self addErrorCode:RTChangePasswordErrorInvalidPassword toErrors:errors];
    }
    
    if ([confirmationPassword length] == 0) {
        [self addErrorCode:RTChangePasswordErrorMissingConfirmationPassword toErrors:errors];
    }
    else if ([password length] >= PASSWORD_MINIMUM_LENGTH && ![confirmationPassword isEqualToString:password]) {
        [self addErrorCode:RTChangePasswordErrorConfirmationPasswordDoesNotMatch toErrors:errors];
    }
}

- (void)addErrorCode:(RTChangePasswordError)code
            toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory changePasswordErrorWithCode:code];
    [errors addObject:error];
}

- (NoArgsCallback)changedCallback {
    return ^{
        [self.delegate changePasswordSucceeded];
    };
}

- (ArrayCallback)notChangedCallback {
    return ^(NSArray *errors) {

    };
}

@end
