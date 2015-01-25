#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationInteractorDelegate.h"

#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistration.h"

#import "RTLoginInteractor.h"
#import "RTAccountRegistrationErrors.h"
#import "RTErrorFactory.h"

@interface RTAccountRegistrationInteractor ()

@property (weak) id<RTAccountRegistrationInteractorDelegate> delegate;
@property RTAccountRegistrationDataManager *dataManager;
@property RTAccountRegistrationValidator *validator;
@property RTLoginInteractor *loginInteractor;

@end

@implementation RTAccountRegistrationInteractor

- (instancetype)initWithDelegate:(id<RTAccountRegistrationInteractorDelegate>)delegate
                     dataManager:(RTAccountRegistrationDataManager *)dataManager
                       validator:(RTAccountRegistrationValidator *)validator
                 loginInteractor:(RTLoginInteractor *)loginInteractor {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
        self.validator = validator;
        self.loginInteractor = loginInteractor;
    }
    return self;
}

- (void)registerAccount:(RTAccountRegistration *)registration {
    NSArray *errors;
    BOOL valid = [self.validator validateAccountRegistration:registration errors:&errors];
    
    if (!valid) {
        [self.delegate registrationFailedWithErrors:errors];
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

- (void)registerAccountFailedWithErrors:(NSArray *)errors {
    [self.delegate registrationFailedWithErrors:errors];
}

- (void)failedToSaveClientCredentials:(RTClientCredentials *)clientCredentials
                          forUsername:(NSString *)username {
    NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:AccountRegistrationUnableToAssociateClientWithDevice];
    [self.delegate registrationWithAutoLoginFailedWithError:error];
}

@end
