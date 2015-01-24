#import "RTAccountRegistrationDataManager.h"
#import "RTAccountRegistrationDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTAccountRegistration.h"
#import "RTClientCredentials.h"

#import "RTServerErrors.h"
#import "RTErrorFactory.h"

@interface RTAccountRegistrationDataManager ()

@property (weak) id<RTAccountRegistrationDataManagerDelegate> delegate;
@property RTClient *client;
@property RTClientCredentialsStore *clientCredentialsStore;

@end

@implementation RTAccountRegistrationDataManager

+ (NSDictionary *)serverMessageToErrorCodeMap {
    return @{
             @"[username] is required": @(AccountRegistrationMissingUsername),
             @"[password] is required": @(AccountRegistrationMissingPassword),
             @"[email] is required": @(AccountRegistrationMissingEmail),
             @"[display_name] is required": @(AccountRegistrationMissingDisplayName),
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

        // TODO: Handle unknown message
        error = [RTErrorFactory accountRegistrationErrorWithCode:[code integerValue]];
        [errors addObject:error];
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
