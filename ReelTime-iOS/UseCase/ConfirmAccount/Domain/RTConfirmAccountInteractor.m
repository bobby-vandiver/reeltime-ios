#import "RTConfirmAccountInteractor.h"
#import "RTConfirmAccountInteractorDelegate.h"
#import "RTConfirmAccountDataManager.h"

@interface RTConfirmAccountInteractor ()

@property id<RTConfirmAccountInteractorDelegate> delegate;
@property RTConfirmAccountDataManager *dataManager;

@end

@implementation RTConfirmAccountInteractor

- (instancetype)initWithDelegate:(id<RTConfirmAccountInteractorDelegate>)delegate
                     dataManager:(RTConfirmAccountDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)sendConfirmationEmail {
    
}

- (void)confirmAccountWithCode:(NSString *)code {
    
}

@end
