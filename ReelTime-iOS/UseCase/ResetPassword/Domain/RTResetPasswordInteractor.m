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
        [self.dataManager submitRequestForResetPasswordEmailForUsername:username withCallback:^{
            [self.delegate resetPasswordEmailSent];
        }];
    }
}

- (void)resetPasswordForCurrentClientWithCode:(NSString *)code
                                     username:(NSString *)username
                                  newPassword:(NSString *)newPassword {
    NSArray *errors;
    BOOL valid = [self.validator validateCode:code username:username newPassword:newPassword errors:&errors];
    
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
    
    [self.dataManager resetPasswordToNewPassword:newPassword
                                     forUsername:username
                               clientCredentials:clientCredentials
                                        withCode:code
                                        callback:^{
                                            [self.delegate resetPasswordSucceeded];
                                        }];
}

- (void)resetPasswordForNewClientWithClientName:(NSString *)clientName
                                           code:(NSString *)code
                                       username:(NSString *)username
                                    newPassword:(NSString *)newPassword {
    
}

- (void)submitRequestForResetPasswordEmailFailedWithErrors:(NSArray *)errors {
    [self.delegate resetPasswordEmailFailedWithErrors:errors];
}

- (void)failedToResetPasswordWithErrors:(NSArray *)errors {
    
}

@end
