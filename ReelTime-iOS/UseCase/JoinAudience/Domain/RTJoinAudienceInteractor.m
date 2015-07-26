#import "RTJoinAudienceInteractor.h"

#import "RTJoinAudienceInteractorDelegate.h"
#import "RTJoinAudienceDataManager.h"

#import "RTJoinAudienceError.h"
#import "RTErrorFactory.h"

@interface RTJoinAudienceInteractor ()

@property id<RTJoinAudienceInteractorDelegate> delegate;
@property RTJoinAudienceDataManager *dataManager;

@end

@implementation RTJoinAudienceInteractor

- (instancetype)initWithDelegate:(id<RTJoinAudienceInteractorDelegate>)delegate
                     dataManager:(RTJoinAudienceDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)joinAudienceForReelId:(NSNumber *)reelId {
    if (reelId != nil) {
        [self.dataManager requestAudienceMembershipForReelId:reelId
                                                 joinSuccess:[self joinAudienceSuccessCallbackForReelId:reelId]
                                                 joinFailure:[self joinAudienceFailureCallbackForReelId:reelId]];
    }
    else {
        NSError *error = [RTErrorFactory joinAudienceErrorWithCode:RTJoinAudienceErrorReelNotFound];
        [self.delegate joinAudienceFailedForReelId:reelId withError:error];
    }
}

- (NoArgsCallback)joinAudienceSuccessCallbackForReelId:(NSNumber *)reelId {
    return ^{
        [self.delegate joinAudienceSucceededForReelId:reelId];
    };
}

- (ErrorCallback)joinAudienceFailureCallbackForReelId:(NSNumber *)reelId {
    return ^(NSError *error) {
        [self.delegate joinAudienceFailedForReelId:reelId withError:error];
    };
}

@end
