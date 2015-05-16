#import "RTResetPasswordInteractor.h"
#import "RTResetPasswordInteractorDelegate.h"

#import "RTResetPasswordDataManager.h"
#import "RTResetPasswordError.h"

#import "RTCurrentUserService.h"
#import "RTClientCredentialsService.h"

#import "RTErrorFactory.h"

@interface RTResetPasswordInteractor ()

@property id<RTResetPasswordInteractorDelegate> delegate;
@property RTResetPasswordDataManager *dataManager;

@property RTCurrentUserService *currentUserService;
@property RTClientCredentialsService *clientCredentialsService;

@end

@implementation RTResetPasswordInteractor

- (instancetype)initWithDelegate:(id<RTResetPasswordInteractorDelegate>)delegate
                     dataManager:(RTResetPasswordDataManager *)dataManager
              currentUserService:(RTCurrentUserService *)currentUserService
        clientCredentialsService:(RTClientCredentialsService *)clientCredentialsService {

    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
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
    
}

- (void)resetPasswordForNewClientWithClientName:(NSString *)clientName
                                           code:(NSString *)code
                                       username:(NSString *)username
                                    newPassword:(NSString *)newPassword {
    
}

@end
