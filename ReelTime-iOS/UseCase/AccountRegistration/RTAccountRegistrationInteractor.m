#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationInteractorDelegate.h"

#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistration.h"

#import "RTLoginInteractor.h"
#import "RTAccountRegistrationErrors.h"
#import "RTErrorFactory.h"

@interface RTAccountRegistrationInteractor ()

@property (weak) id<RTAccountRegistrationInteractorDelegate> delegate;
@property RTAccountRegistrationDataManager *dataManager;
@property RTLoginInteractor *loginInteractor;

@end

@implementation RTAccountRegistrationInteractor

- (instancetype)initWithDelegate:(id<RTAccountRegistrationInteractorDelegate>)delegate
                     dataManager:(RTAccountRegistrationDataManager *)dataManager
                 loginInteractor:(RTLoginInteractor *)loginInteractor {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
        self.loginInteractor = loginInteractor;
    }
    return self;
}

- (void)registerAccount:(RTAccountRegistration *)registration {
    RTAccountRegistrationErrors errorCode;
    BOOL valid = [self validateRegistration:registration errorCode:&errorCode];
    if (!valid) {
        [self registrationFailedWithErrorCode:errorCode];
        return;
    }
   
    NSString *username = registration.username;
    NSString *password = registration.password;
    
    [self.dataManager registerAccount:registration callback:^(RTClientCredentials *clientCredentials) {
        [self.dataManager saveClientCredentials:clientCredentials forUsername:username callback:^{
            [self.loginInteractor loginWithUsername:username password:password];
        }];
    }];
}

- (BOOL)validateRegistration:(RTAccountRegistration *)registration
                   errorCode:(RTAccountRegistrationErrors *)errorCode {
    BOOL valid = YES;
    
    if ([registration.username length] == 0) {
        *errorCode = AccountRegistrationMissingUsername;
        valid = NO;
    }
    else if([registration.password length] == 0) {
        *errorCode = AccountRegistrationMissingPassword;
        valid = NO;
    }
    else if ([registration.confirmationPassword length] == 0) {
        *errorCode = AccountRegistrationMissingConfirmationPassword;
        valid = NO;
    }
    else if ([registration.email length] == 0) {
        *errorCode = AccountRegistrationMissingEmail;
        valid = NO;
    }
    else if ([registration.displayName length] == 0) {
        *errorCode = AccountRegistrationMissingDisplayName;
        valid = NO;
    }
    else if ([registration.clientName length] == 0) {
        *errorCode = AccountRegistrationMissingClientName;
        valid = NO;
    }
    
    return valid;
}

- (void)registrationFailedWithErrorCode:(RTAccountRegistrationErrors)code {
    NSError *registrationError = [RTErrorFactory accountRegistrationErrorWithCode:code];
    [self.delegate registrationFailedWithErrors:@[registrationError]];
}

@end
