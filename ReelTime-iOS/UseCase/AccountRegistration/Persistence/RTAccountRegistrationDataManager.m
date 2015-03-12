#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTErrorFactory.h"

@interface RTAccountRegistrationDataManager ()

@property (weak) id<RTAccountRegistrationDataManagerDelegate> delegate;
@property RTClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;
@property RTClientCredentialsStore *clientCredentialsStore;

@end

@implementation RTAccountRegistrationDataManager

+ (NSDictionary *)serverMessageToErrorCodeMap {
    return @{
             @"[username] is required": @(RTAccountRegistrationErrorMissingUsername),
             @"[username] must be 2-15 alphanumeric characters long": @(RTAccountRegistrationErrorInvalidUsername),
             @"[username] is not available": @(RTAccountRegistrationErrorUsernameIsUnavailable),
             
             @"[password] is required": @(RTAccountRegistrationErrorMissingPassword),
             @"[password] must be at least 6 characters long": @(RTAccountRegistrationErrorInvalidPassword),
             
             @"[email] is required": @(RTAccountRegistrationErrorMissingEmail),
             @"[email] is not a valid e-mail address": @(RTAccountRegistrationErrorInvalidEmail),
             @"[email] is not available": @(RTAccountRegistrationErrorEmailIsUnavailable),
             
             @"[display_name] is required": @(RTAccountRegistrationErrorMissingDisplayName),
             @"[display_name] must be 2-20 alphanumeric or space characters long": @(RTAccountRegistrationErrorInvalidDisplayName),
             
             @"[client_name] is required": @(RTAccountRegistrationErrorMissingClientName),
             @"Unable to register. Please try again.": @(RTAccountRegistrationErrorRegistrationServiceUnavailable)
             };
}

- (instancetype)initWithDelegate:(id<RTAccountRegistrationDataManagerDelegate>)delegate
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

- (void)registerAccount:(RTAccountRegistration *)registration
               callback:(void (^)(RTClientCredentials *))callback {

    id successCallback = ^(RTClientCredentials *clientCredentials) {
        callback(clientCredentials);
    };
    
    id failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *registrationErrors = [self convertServerErrors:serverErrors];
        [self.delegate registerAccountFailedWithErrors:registrationErrors];
    };
    
    [self.client registerAccount:registration
                         success:successCallback
                         failure:failureCallback];
}

- (NSArray *)convertServerErrors:(RTServerErrors *)serverErrors {
    NSDictionary *mapping = [RTAccountRegistrationDataManager serverMessageToErrorCodeMap];

    id converter = ^NSError *(NSInteger code) {
        return [RTErrorFactory accountRegistrationErrorWithCode:code];
    };
    
    return [self.serverErrorsConverter convertServerErrors:serverErrors
                                               withMapping:mapping
                                                 converter:converter];
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
