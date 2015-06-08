#import "RTRevokeClientInteractor.h"

#import "RTRevokeClientInteractorDelegate.h"
#import "RTRevokeClientDataManager.h"

#import "RTValidator.h"

#import "RTRevokeClientError.h"
#import "RTErrorFactory.h"

@interface RTRevokeClientInteractor ()

@property id<RTRevokeClientInteractorDelegate> delegate;
@property RTRevokeClientDataManager *dataManager;
@property RTValidator *validator;

@end

@implementation RTRevokeClientInteractor

- (instancetype)initWithDelegate:(id<RTRevokeClientInteractorDelegate>)delegate
                     dataManager:(RTRevokeClientDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
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
                                 revocationSuccees:[self revocationSuccessCallback]
                                           failure:[self revocationFailureCallback]];
    }
    else {
        [self.delegate clientRevocationFailedWithErrors:errors];
    }
}

- (void)validateClientId:(NSString *)clientId
                  errors:(NSMutableArray *)errors {
    if (clientId.length == 0) {
        NSError *error = [RTErrorFactory revokeClientErrorWithCode:RTRevokeClientErrorMissingClientId];
        [errors addObject:error];
    }
}

- (NoArgsCallback)revocationSuccessCallback {
    return ^{
        [self.delegate clientRevocationSucceeded];
    };
}

- (ArrayCallback)revocationFailureCallback {
    return ^(NSArray *errors) {
        [self.delegate clientRevocationFailedWithErrors:errors];
    };
}

@end
