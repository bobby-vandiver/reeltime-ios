#import "RTChangeDisplayNameInteractor.h"

#import "RTChangeDisplayNameInteractorDelegate.h"
#import "RTChangeDisplayNameDataManager.h"

#import "RTValidator.h"
#import "RTChangeDisplayNameError.h"

@interface RTChangeDisplayNameInteractor ()

@property id<RTChangeDisplayNameInteractorDelegate> delegate;
@property RTChangeDisplayNameDataManager *dataManager;
@property RTValidator *validator;

@end

@implementation RTChangeDisplayNameInteractor

- (instancetype)initWithDelegate:(id<RTChangeDisplayNameInteractorDelegate>)delegate
                     dataManager:(RTChangeDisplayNameDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
        self.validator = [[RTValidator alloc] init];
    }
    return self;
}

- (void)changeDisplayName:(NSString *)displayName {

    NSArray *errors;
    BOOL valid = [self.validator validateWithErrors:&errors validationBlock:^(NSMutableArray *errorContainer) {
        [self validateDisplayName:displayName errors:errorContainer];
    }];
    
    if (valid) {
        [self.dataManager changeDisplayName:displayName
                                    changed:[self changedCallback]
                                 notChanged:[self notChangedCallback]];
    }
    else {
        [self.delegate changeDisplayNameFailedWithErrors:errors];
    }
}

- (void)validateDisplayName:(NSString *)displayName
                     errors:(NSMutableArray *)errors {

    [self.validator validateDisplayName:displayName
                             withDomain:RTChangeDisplayNameErrorDomain
                            missingCode:RTChangeDisplayNameErrorMissingDisplayName
                            invalidCode:RTChangeDisplayNameErrorInvalidDisplayName
                                 errors:errors];
}

- (NoArgsCallback)changedCallback {
    return ^{
        [self.delegate changeDisplayNameSucceeded];
    };
}

- (ArrayCallback)notChangedCallback {
    return ^(NSArray *errors) {
        [self.delegate changeDisplayNameFailedWithErrors:errors];
    };
};

@end
