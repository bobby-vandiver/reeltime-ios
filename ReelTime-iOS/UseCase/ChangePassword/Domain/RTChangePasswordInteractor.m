#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordInteractorDelegate.h"
#import "RTChangePasswordDataManager.h"

@interface RTChangePasswordInteractor ()

@property (weak) id<RTChangePasswordInteractorDelegate> delegate;
@property RTChangePasswordDataManager *dataManager;

@end

@implementation RTChangePasswordInteractor

- (instancetype)initWithDelegate:(id<RTChangePasswordInteractorDelegate>)delegate
                     dataManager:(RTChangePasswordDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)changePassword:(NSString *)password
  confirmationPassword:(NSString *)confirmationPassword {
    
    // TODO: validation
    [self.dataManager changePassword:password
                             changed:[self changedCallback]
                          notChanged:[self notChangedCallback]];
}

- (NoArgsCallback)changedCallback {
    return ^{
        [self.delegate changePasswordSucceeded];
    };
}

- (ArrayCallback)notChangedCallback {
    return ^(NSArray *errors) {

    };
}

@end
