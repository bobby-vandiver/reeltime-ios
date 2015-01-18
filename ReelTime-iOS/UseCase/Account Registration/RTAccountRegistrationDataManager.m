#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationInteractor.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

@interface RTAccountRegistrationDataManager ()

@property RTAccountRegistrationInteractor *interactor;
@property RTClient *client;
@property RTClientCredentialsStore *clientCredentialsStore;

@end

@implementation RTAccountRegistrationDataManager

- (instancetype)initWithInteractor:(RTAccountRegistrationInteractor *)interactor
                            client:(RTClient *)client
            clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore {
    self = [super init];
    if (self) {
        self.interactor = interactor;
        self.client = client;
        self.clientCredentialsStore = clientCredentialsStore;
    }
    return self;
}

- (void)registerAccount:(RTAccountRegistration *)registration
               callback:(void (^)(RTClientCredentials *))callback {
    
}

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username {
    
}

@end
