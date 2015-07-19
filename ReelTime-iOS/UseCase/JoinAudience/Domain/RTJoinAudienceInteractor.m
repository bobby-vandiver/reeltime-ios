#import "RTJoinAudienceInteractor.h"

#import "RTJoinAudienceInteractorDelegate.h"
#import "RTJoinAudienceDataManager.h"

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
    [self.dataManager requestAudienceMembershipForReelId:reelId
                                             joinSuccess:[self joinAudienceSuccessCallbackForReelId:reelId]
                                             joinFailure:[self joinAudienceFailureCallbackForReelId:reelId]];
}

- (NoArgsCallback)joinAudienceSuccessCallbackForReelId:(NSNumber *)reelId {
    return ^{
        [self.delegate joinAudienceSucceedForReelId:reelId];
    };
}

- (ErrorCallback)joinAudienceFailureCallbackForReelId:(NSNumber *)reelId {
    return ^(NSError *error) {
        [self.delegate joinAudienceFailedForReelId:reelId withError:error];
    };
}

@end
