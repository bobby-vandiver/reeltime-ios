#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistration.h"

#import "RTLoginInteractor.h"
#import "RTAccountRegistrationErrors.h"
#import "RTErrorFactory.h"

@interface RTAccountRegistrationInteractor ()

@property RTAccountRegistrationPresenter *presenter;
@property RTAccountRegistrationDataManager *dataManager;
@property RTLoginInteractor *loginInteractor;

@end

@implementation RTAccountRegistrationInteractor

- (instancetype)initWithPresenter:(RTAccountRegistrationPresenter *)presenter
                      dataManager:(RTAccountRegistrationDataManager *)dataManager
                  loginInteractor:(RTLoginInteractor *)loginInteractor {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.dataManager = dataManager;
        self.loginInteractor = loginInteractor;
    }
    return self;
}

- (void)registerAccountWithUsername:(NSString *)username
                           password:(NSString *)password
               confirmationPassword:(NSString *)confirmationPassword
                              email:(NSString *)email
                        displayName:(NSString *)displayName
                         clientName:(NSString *)clientName {
    RTAccountRegistrationErrors errorCode;
    BOOL valid = [self isValidRegistrationRequestForUsername:username
                                                    password:password
                                        confirmationPassword:confirmationPassword
                                                       email:email
                                                 displayName:displayName
                                                  clientName:clientName
                                                   errorCode:&errorCode];
    
    if (!valid) {
        [self registrationFailedWithErrorCode:errorCode];
        return;
    }
   
    RTAccountRegistration *registration = [[RTAccountRegistration alloc] initWithUsername:username
                                                                                 password:password
                                                                                    email:email
                                                                              displayName:displayName
                                                                               clientName:clientName];
    
    [self.dataManager registerAccount:registration callback:^(RTClientCredentials *clientCredentials) {
        [self.dataManager saveClientCredentials:clientCredentials forUsername:username callback:^{
            [self.loginInteractor loginWithUsername:username password:password];
        }];
    }];
}

- (BOOL)isValidRegistrationRequestForUsername:(NSString *)username
                                     password:(NSString *)password
                         confirmationPassword:(NSString *)confirmationPassword
                                        email:(NSString *)email
                                  displayName:(NSString *)displayName
                                   clientName:(NSString *)clientName
                                    errorCode:(RTAccountRegistrationErrors *)errorCode {
    BOOL valid = YES;
    
    if ([username length] == 0) {
        *errorCode = AccountRegistrationMissingUsername;
        valid = NO;
    }
    else if([password length] == 0) {
        *errorCode = AccountRegistrationMissingPassword;
        valid = NO;
    }
    else if ([confirmationPassword length] == 0) {
        *errorCode = AccountRegistrationMissingConfirmationPassword;
        valid = NO;
    }
    else if ([email length] == 0) {
        *errorCode = AccountRegistrationMissingEmail;
        valid = NO;
    }
    else if ([displayName length] == 0) {
        *errorCode = AccountRegistrationMissingDisplayName;
        valid = NO;
    }
    else if ([clientName length] == 0) {
        *errorCode = AccountRegistrationMissingClientName;
        valid = NO;
    }
    
    return valid;
}

- (void)registrationFailedWithErrorCode:(RTAccountRegistrationErrors)code {
    NSError *registrationError = [RTErrorFactory accountRegistrationErrorWithCode:code];
    [self.presenter registrationFailedWithErrors:@[registrationError]];
}

@end
