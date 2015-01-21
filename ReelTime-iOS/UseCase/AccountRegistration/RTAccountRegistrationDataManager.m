#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

@interface RTAccountRegistrationDataManager ()

@property (weak) id<RTAccountRegistrationDataManagerDelegate> delegate;
@property RTClient *client;
@property RTClientCredentialsStore *clientCredentialsStore;

@end

@implementation RTAccountRegistrationDataManager

- (instancetype)initWithDelegate:(id<RTAccountRegistrationDataManagerDelegate>)delegate
                          client:(RTClient *)client
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.client = client;
        self.clientCredentialsStore = clientCredentialsStore;
    }
    return self;
}

- (void)registerAccount:(RTAccountRegistration *)registration
               callback:(void (^)(RTClientCredentials *))callback {
    
}

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                     callback:(void (^)())callback {
    
}

@end
