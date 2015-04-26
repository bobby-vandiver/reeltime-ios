#import "RTDeviceRegistrationDataManager.h"
#import "RTDeviceRegistrationDataManagerDelegate.h"

#import "RTClient.h"

#import "RTServerErrorsConverter.h"
#import "RTClientCredentialsStore.h"

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

+ (NSDictionary *)serverMessageToErrorCodeMap {
    return @{
             @"[username] is required": @(RTDeviceRegistrationErrorMissingUsername),
             @"[password] is required": @(RTDeviceRegistrationErrorMissingPassword),
             @"[client_name] is required": @(RTDeviceRegistrationErrorMissingClientName),
             @"Invalid credentials": @(RTDeviceRegistrationErrorInvalidCredentials)
             };
}

- (instancetype)initWithDelegate:(id<RTDeviceRegistrationDataManagerDelegate>)delegate
                          client:(RTClient *)client
           serverErrorsConverter:(RTServerErrorsConverter *)serverErrorsConverter
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.client = client;
        self.serverErrorsConverter = serverErrorsConverter;
        self.clientCredentialsStore = clientCredentialsStore;
    }
    return self;
}

- (void)fetchClientCredentialsForClientName:(NSString *)clientName
                        withUserCredentials:(RTUserCredentials *)userCredentials
                                   callback:(void (^)(RTClientCredentials *))callback {

    ClientCredentialsCallback successCallback = ^(RTClientCredentials *clientCredentials) {
        callback(clientCredentials);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *deviceRegistrationErrors = [self convertServerErrors:serverErrors];
        [self.delegate deviceRegistrationDataOperationFailedWithErrors:deviceRegistrationErrors];
    };
    
    [self.client registerClientWithClientName:clientName
                              userCredentials:userCredentials
                                      success:successCallback
                                      failure:failureCallback];
}

- (NSArray *)convertServerErrors:(RTServerErrors *)serverErrors {
    NSDictionary *mapping = [RTDeviceRegistrationDataManager serverMessageToErrorCodeMap];
    
    id converter = ^NSError *(NSInteger code) {
        return [RTErrorFactory deviceRegistrationErrorWithCode:code];
    };
    
    return [self.serverErrorsConverter convertServerErrors:serverErrors
                                               withMapping:mapping
                                                 converter:converter];
}

- (void)storeClientCredentials:(RTClientCredentials *)clientCredentials
                   forUsername:(NSString *)username callback:(void (^)())callback {
}

@end
