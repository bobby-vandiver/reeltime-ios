#import "RTRevokeClientInteractor.h"

#import "RTRevokeClientInteractorDelegate.h"
#import "RTRevokeClientDataManager.h"

#import "RTCurrentUserService.h"
#import "RTValidator.h"

#import "RTRevokeClientError.h"
#import "RTErrorFactory.h"

#import "RTClientCredentials.h"

@interface RTRevokeClientInteractor ()

@property id<RTRevokeClientInteractorDelegate> delegate;
@property RTRevokeClientDataManager *dataManager;

@property RTCurrentUserService *currentUserService;
@property RTValidator *validator;

@end

@implementation RTRevokeClientInteractor

- (instancetype)initWithDelegate:(id<RTRevokeClientInteractorDelegate>)delegate
                     dataManager:(RTRevokeClientDataManager *)dataManager
              currentUserService:(RTCurrentUserService *)currentUserService {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
        self.currentUserService = currentUserService;
        self.validator = [[RTValidator alloc] init];
    }
    return self;
}

- (void)revokeClientWithClientId:(NSString *)clientId {
    
    NSArray *errors;
    BOOL valid = [self.validator validateWithErrors:&errors validationBlock:^(NSMutableArray *errorContainer) {
        [self validateClientId:clientId errors:errorContainer];
    }];
    
    if (valid) {
        [self.dataManager revokeClientWithClientId:clientId
                                 revocationSuccees:[self revocationSuccessCallbackForClientId:clientId]
                                           failure:[self revocationFailureCallbackForClientId:clientId]];
    }
    else {
        [self.delegate clientRevocationFailedForClientWithClientId:clientId errors:errors];
    }
}

- (void)validateClientId:(NSString *)clientId
                  errors:(NSMutableArray *)errors {
    if (clientId.length == 0) {
        NSError *error = [RTErrorFactory revokeClientErrorWithCode:RTRevokeClientErrorMissingClientId];
        [errors addObject:error];
    }
}

- (NoArgsCallback)revocationSuccessCallbackForClientId:(NSString *)clientId {
    return ^{
        RTClientCredentials *clientCredentials = [self.currentUserService clientCredentialsForCurrentUser];
        BOOL currentClient = [clientCredentials.clientId isEqual:clientId];
        [self.delegate clientRevocationSucceededForClientWithClientId:clientId currentClient:currentClient];
    };
}

- (ArrayCallback)revocationFailureCallbackForClientId:(NSString *)clientId {
    return ^(NSArray *errors) {
        [self.delegate clientRevocationFailedForClientWithClientId:clientId errors:errors];
    };
}

@end
