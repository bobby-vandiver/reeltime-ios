#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistration.h"

#import "RTLoginInteractor.h"

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
    // TODO: Validate registration
   
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

@end
