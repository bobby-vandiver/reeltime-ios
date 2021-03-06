#import "RTResetPasswordInteractor.h"
#import "RTResetPasswordInteractorDelegate.h"

#import "RTResetPasswordDataManager.h"
#import "RTResetPasswordValidator.h"

#import "RTCurrentUserService.h"
#import "RTClientCredentialsService.h"

#import "RTErrorFactory.h"
#import "RTResetPasswordError.h"

#import "RTLogging.h"

@interface RTResetPasswordInteractor ()

@property id<RTResetPasswordInteractorDelegate> delegate;

@property RTResetPasswordDataManager *dataManager;
@property RTResetPasswordValidator *validator;

@property RTCurrentUserService *currentUserService;
@property RTClientCredentialsService *clientCredentialsService;

@end

@implementation RTResetPasswordInteractor

- (instancetype)initWithDelegate:(id<RTResetPasswordInteractorDelegate>)delegate
                     dataManager:(RTResetPasswordDataManager *)dataManager
                       validator:(RTResetPasswordValidator *)validator
              currentUserService:(RTCurrentUserService *)currentUserService
        clientCredentialsService:(RTClientCredentialsService *)clientCredentialsService {
    
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
        self.validator = validator;
        self.currentUserService = currentUserService;
        self.clientCredentialsService = clientCredentialsService;
    }
    return self;
}

- (void)sendResetPasswordEmailForUsername:(NSString *)username {
    if (username.length == 0) {
        NSError *error = [RTErrorFactory resetPasswordErrorWithCode:RTResetPasswordErrorMissingUsername];
        [self.delegate resetPasswordEmailFailedWithErrors:@[error]];
    }
    else {
        [self.dataManager submitRequestForResetPasswordEmailForUsername:username
                                                              emailSent:[self emailSentCallback]
                                                            emailFailed:[self emailFailedCallback]];
    }
}

- (NoArgsCallback)emailSentCallback {
    return ^{
        [self.delegate resetPasswordEmailSent];
    };
}

- (ArrayCallback)emailFailedCallback {
    return ^(NSArray *errors) {
        [self.delegate resetPasswordEmailFailedWithErrors:errors];
    };
}

- (void)resetPasswordForCurrentClientWithCode:(NSString *)code
                                     username:(NSString *)username
                                     password:(NSString *)password
                         confirmationPassword:(NSString *)confirmationPassword {
    NSArray *errors;
    BOOL valid = [self.validator validateCode:code username:username password:password confirmationPassword:confirmationPassword errors:&errors];
    
    if (!valid) {
        [self.delegate resetPasswordFailedWithErrors:errors];
        return;
    }
    
    RTClientCredentials *clientCredentials = [self.currentUserService clientCredentialsForCurrentUser];
    
    if (!clientCredentials) {
        DDLogWarn(@"Unable to find client credentials for registering current device");
        
        NSError *error = [RTErrorFactory resetPasswordErrorWithCode:RTResetPasswordErrorUnknownClient];
        [self.delegate resetPasswordFailedWithErrors:@[error]];
        
        return;
    }
    
    [self.dataManager resetPasswordToNewPassword:password
                                     forUsername:username
                               clientCredentials:clientCredentials
                                        withCode:code
                            passwordResetSuccess:[self currentClientResetSuccessCallback]
                                         failure:[self resetFailureCallback]];
}

- (NoArgsCallback)currentClientResetSuccessCallback {
    return ^{
        [self.delegate resetPasswordSucceeded];
    };
}

- (void)resetPasswordForNewClientWithClientName:(NSString *)clientName
                                           code:(NSString *)code
                                       username:(NSString *)username
                                       password:(NSString *)password
                           confirmationPassword:(NSString *)confirmationPassword {
    NSArray *errors;
    BOOL valid = [self.validator validateCode:code username:username password:password confirmationPassword:confirmationPassword clientName:clientName errors:&errors];
    
    if (!valid) {
        [self.delegate resetPasswordFailedWithErrors:errors];
        return;
    }
    
    [self.dataManager resetPasswordToNewPassword:password
                                     forUsername:username
                                        withCode:code
                 registerNewClientWithClientName:clientName
                            passwordResetSuccess:[self newClientResetSuccessCallbackForUsername:username]
                                         failure:[self resetFailureCallback]];
}

- (ClientCredentialsCallback)newClientResetSuccessCallbackForUsername:(NSString *)username {
    void (^savedClientCredentialsCallback)() = ^{
        [self.delegate resetPasswordSucceeded];
    };
    
    void (^failedToSaveClientCredentialsCallback)(NSError *) = ^(NSError *error) {
        DDLogError(@"Failed to save client credentials: %@", error);
        
        NSError *saveError = [RTErrorFactory resetPasswordErrorWithCode:RTResetPasswordErrorFailedToSaveClientCredentials];
        [self.delegate resetPasswordFailedWithErrors:@[saveError]];
    };
    
    return ^(RTClientCredentials *clientCredentials) {
        [self.clientCredentialsService saveClientCredentials:clientCredentials
                                                 forUsername:username
                                                     success:savedClientCredentialsCallback
                                                     failure:failedToSaveClientCredentialsCallback];
    };
}

- (ArrayCallback)resetFailureCallback {
    return ^(NSArray *errors) {
        [self.delegate resetPasswordFailedWithErrors:errors];
    };
}

@end
