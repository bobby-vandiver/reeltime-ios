#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

#import "RTServerErrors.h"
#import "RTErrorFactory.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface RTAccountRegistrationDataManager ()

@property (weak) id<RTAccountRegistrationDataManagerDelegate> delegate;
@property RTClient *client;
@property RTClientCredentialsStore *clientCredentialsStore;

@end

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@implementation RTAccountRegistrationDataManager

+ (NSDictionary *)serverMessageToErrorCodeMap {
    return @{
             @"[username] is required": @(AccountRegistrationMissingUsername),
             @"[username] must be 2-15 alphanumeric characters long": @(AccountRegistrationInvalidUsername),
             
             @"[password] is required": @(AccountRegistrationMissingPassword),
             @"[password] must be at least 6 characters long": @(AccountRegistrationInvalidPassword),
             
             @"[email] is required": @(AccountRegistrationMissingEmail),
             @"[email] is not a valid e-mail address": @(AccountRegistrationInvalidEmail),
             
             @"[display_name] is required": @(AccountRegistrationMissingDisplayName),
             @"[display_name] must be 2-20 alphanumeric or space characters long": @(AccountRegistrationInvalidDisplayName),
             
             @"[client_name] is required": @(AccountRegistrationMissingClientName),
             };
}

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

    id successCallback = ^(RTClientCredentials *clientCredentials) {
        callback(clientCredentials);
    };
    
    id failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *registrationErrors;
        [self convertServerErrors:serverErrors toRegistrationErrors:&registrationErrors];
        [self.delegate accountRegistrationDataOperationFailedWithErrors:registrationErrors];
    };
    
    [self.client registerAccount:registration
                         success:successCallback
                         failure:failureCallback];
}

- (void)convertServerErrors:(RTServerErrors *)serverErrors
       toRegistrationErrors:(NSArray *__autoreleasing *)registrationErrors {
    NSDictionary *conversionMap = [RTAccountRegistrationDataManager serverMessageToErrorCodeMap];

    NSMutableArray *errors = [[NSMutableArray alloc] init];
    NSError *error;
    
    for (NSString *message in serverErrors.errors) {
        NSNumber *code = [conversionMap objectForKey:message];
        
        if (code) {
            error = [RTErrorFactory accountRegistrationErrorWithCode:[code integerValue]];
            [errors addObject:error];
        }
        else {
            DDLogWarn(@"Received unknown server messsage: %@", message);
        }
    }
    
    if (registrationErrors) {
        *registrationErrors = errors;
    }
}

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                     callback:(void (^)())callback {
    
}

@end
