#import "RTDeviceRegistrationInteractor.h"

#import "RTDeviceRegistrationInteractorDelegate.h"
#import "RTDeviceRegistrationDataManager.h"

#import "RTDeviceRegistrationError.h"
#import "RTErrorFactory.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

@interface RTDeviceRegistrationInteractor ()

@property (weak) id<RTDeviceRegistrationInteractorDelegate> delegate;
@property RTDeviceRegistrationDataManager *dataManager;

@end

@implementation RTDeviceRegistrationInteractor

- (instancetype)initWithDelegate:(id<RTDeviceRegistrationInteractorDelegate>)delegate
                     dataManager:(RTDeviceRegistrationDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)registerDeviceWithClientName:(NSString *)clientName
                            username:(NSString *)username
                            password:(NSString *)password {
    
    NSArray *errors;
    BOOL valid = [self validateClientName:clientName username:username password:password errors:&errors];

    if (!valid) {
        [self.delegate deviceRegistrationFailedWithErrors:errors];
        return;
    }
    
    RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                            password:password];
    
    [self.dataManager fetchClientCredentialsForClientName:clientName
                                      withUserCredentials:userCredentials
                                                 callback:^(RTClientCredentials *clientCredentials) {
         [self.dataManager storeClientCredentials:clientCredentials forUsername:username callback:^{
             [self.delegate deviceRegistrationSucceeded];
         }];
    }];
}

- (BOOL)validateClientName:(NSString *)clientName
                  username:(NSString *)username
                  password:(NSString *)password
                    errors:(NSArray * __autoreleasing *)errors {
    BOOL valid = YES;
    NSMutableArray *errorContainer = [NSMutableArray array];
    
    if (clientName.length == 0) {
        [errorContainer addObject:[RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingClientName]];
    }
    if (username.length == 0) {
        [errorContainer addObject:[RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingUsername]];
    }
    if (password.length == 0) {
        [errorContainer addObject:[RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingPassword]];
    }
    
    if (errorContainer.count > 0) {
        valid = NO;
        
        if (errors) {
            *errors = errorContainer;
        }
    }
    
    return valid;
}

- (void)deviceRegistrationDataOperationFailedWithErrors:(NSArray *)errors {
    [self.delegate deviceRegistrationFailedWithErrors:errors];
}

@end
