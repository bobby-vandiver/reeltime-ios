#import "RTDeviceRegistrationDataManager.h"
#import "RTDeviceRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTDeviceRegistrationServerErrorMapping.h"
#import "RTServerErrorsConverter.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

#import "RTErrorFactory.h"

@interface RTDeviceRegistrationDataManager ()

@property (weak) id<RTDeviceRegistrationDataManagerDelegate> delegate;
@property RTClient *client;

@property RTServerErrorsConverter *serverErrorsConverter;
@property RTClientCredentialsStore *clientCredentialsStore;

@end

@implementation RTDeviceRegistrationDataManager

- (instancetype)initWithDelegate:(id<RTDeviceRegistrationDataManagerDelegate>)delegate
                          client:(RTClient *)client
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.client = client;
        self.clientCredentialsStore = clientCredentialsStore;

        RTDeviceRegistrationServerErrorMapping *mapping = [[RTDeviceRegistrationServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)fetchClientCredentialsForClientName:(NSString *)clientName
                        withUserCredentials:(RTUserCredentials *)userCredentials
                                   callback:(ClientCredentialsCallback)callback {

    ClientCredentialsCallback successCallback = ^(RTClientCredentials *clientCredentials) {
        callback(clientCredentials);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *deviceRegistrationErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        [self.delegate deviceRegistrationDataOperationFailedWithErrors:deviceRegistrationErrors];
    };
    
    [self.client registerClientWithClientName:clientName
                              userCredentials:userCredentials
                                      success:successCallback
                                      failure:failureCallback];
}

- (void)storeClientCredentials:(RTClientCredentials *)clientCredentials
                   forUsername:(NSString *)username
                      callback:(NoArgsCallback)callback {
    NSError *storeError;
    BOOL success = [self.clientCredentialsStore storeClientCredentials:clientCredentials
                                                           forUsername:username
                                                                 error:&storeError];
    if (success) {
        callback();
    }
    else {
        NSError *error = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorUnableToStoreClientCredentials
                                                           originalError:storeError];
        [self.delegate deviceRegistrationDataOperationFailedWithErrors:@[error]];
    }
}

@end
