#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistration.h"

@interface RTAccountRegistrationInteractor ()

@property RTAccountRegistrationPresenter *presenter;
@property RTAccountRegistrationDataManager *dataManager;

@end

@implementation RTAccountRegistrationInteractor

- (instancetype)initWithPresenter:(RTAccountRegistrationPresenter *)presenter
                      dataManager:(RTAccountRegistrationDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)registerAccountWithUsername:(NSString *)username
                           password:(NSString *)password
               confirmationPassword:(NSString *)confirmationPassword
                              email:(NSString *)email
                        displayName:(NSString *)displayName
                         clientName:(NSString *)clientName {
    // Validate registration
    // Request registration from data manager
    
    RTAccountRegistration *registration = [[RTAccountRegistration alloc] initWithUsername:username
                                                                                 password:password
                                                                                    email:email
                                                                              displayName:displayName
                                                                               clientName:clientName];
    
    (void)registration;
}

@end
