#import "RTRemoveAccountInteractor.h"

#import "RTRemoveAccountInteractorDelegate.h"
#import "RTRemoveAccountDataManager.h"

@interface RTRemoveAccountInteractor ()

@property id<RTRemoveAccountInteractorDelegate> delegate;
@property RTRemoveAccountDataManager *dataManager;

@end

@implementation RTRemoveAccountInteractor

- (instancetype)initWithDelegate:(id<RTRemoveAccountInteractorDelegate>)delegate
                     dataManager:(RTRemoveAccountDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)removeAccount {
    [self.dataManager removeAccount:[self removeAccountSuccessCallback]
                            failure:[self removeAccountFailureCallback]];
}

- (NoArgsCallback)removeAccountSuccessCallback {
    return ^{
        [self.delegate removeAccountSucceeded];
    };
}

- (ErrorCallback)removeAccountFailureCallback {
    return ^(NSError *error) {
        [self.delegate removeAccountFailedWithError:error];
    };
}

@end
