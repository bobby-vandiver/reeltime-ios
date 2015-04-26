#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTAccountRegistrationServerErrorMapping.h"
#import "RTErrorFactory.h"

@interface RTAccountRegistrationDataManager ()

@property (weak) id<RTAccountRegistrationDataManagerDelegate> delegate;
@property RTClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;
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

        RTAccountRegistrationServerErrorMapping *mapping = [[RTAccountRegistrationServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)registerAccount:(RTAccountRegistration *)registration
               callback:(void (^)(RTClientCredentials *))callback {

    id successCallback = ^(RTClientCredentials *clientCredentials) {
        callback(clientCredentials);
    };
    
    id failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *registrationErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        [self.delegate registerAccountFailedWithErrors:registrationErrors];
    };
    
    [self.client registerAccount:registration
                         success:successCallback
                         failure:failureCallback];
}

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                     callback:(void (^)())callback {
    NSError *storeError;
    BOOL success = [self.clientCredentialsStore storeClientCredentials:clientCredentials
                                                           forUsername:username
                                                                 error:&storeError];
    if (success) {
        callback();
    }
    else {
        [self.delegate failedToSaveClientCredentials:clientCredentials forUsername:username];
    }
}

@end
