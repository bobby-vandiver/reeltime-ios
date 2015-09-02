#import "RTDeleteReelInteractor.h"

#import "RTDeleteReelInteractorDelegate.h"
#import "RTDeleteReelDataManager.h"

#import "RTDeleteReelError.h"
#import "RTErrorFactory.h"

@interface RTDeleteReelInteractor ()

@property id<RTDeleteReelInteractorDelegate> delegate;
@property RTDeleteReelDataManager *dataManager;

@end

@implementation RTDeleteReelInteractor

- (instancetype)initWithDelegate:(id<RTDeleteReelInteractorDelegate>)delegate
                     dataManager:(RTDeleteReelDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)deleteReelWithReelId:(NSNumber *)reelId {
    if (reelId) {
        [self.dataManager deleteReelWithReelId:[reelId integerValue]
                                       success:[self deleteReelSuccessCallbackWithReelId:reelId]
                                       failure:[self deleteReelFailureCallbackWithReelId:reelId]];
    }
    else {
        NSError *error = [RTErrorFactory deleteReelErrorWithCode:RTDeleteReelErrorReelNotFound];
        [self.delegate deleteReelFailedForReelId:reelId withError:error];
    }
}

- (NoArgsCallback)deleteReelSuccessCallbackWithReelId:(NSNumber *)reelId {
    return ^{
        [self.delegate deleteReelSucceededForReelId:reelId];
    };
}

- (ErrorCallback)deleteReelFailureCallbackWithReelId:(NSNumber *)reelId {
    return ^(NSError *error) {
        [self.delegate deleteReelFailedForReelId:reelId withError:error];
    };
};

@end
