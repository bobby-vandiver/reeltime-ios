#import "RTLeaveAudienceInteractor.h"

#import "RTLeaveAudienceInteractorDelegate.h"
#import "RTLeaveAudienceDataManager.h"

#import "RTLeaveAudienceError.h"
#import "RTErrorFactory.h"

@interface RTLeaveAudienceInteractor ()

@property id<RTLeaveAudienceInteractorDelegate> delegate;
@property RTLeaveAudienceDataManager *dataManager;

@end

@implementation RTLeaveAudienceInteractor

- (instancetype)initWithDelegate:(id<RTLeaveAudienceInteractorDelegate>)delegate
                     dataManager:(RTLeaveAudienceDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)leaveAudienceForReelId:(NSNumber *)reelId {
    if (reelId != nil) {
        [self.dataManager requestAudienceLeaveForReelId:reelId
                                           leaveSuccess:[self leaveAudienceSuccessCallbackForReelId:reelId]
                                           leaveFailure:[self leaveAudienceFailureCallbackForReelId:reelId]];
    }
    else {
        NSError *error = [RTErrorFactory leaveAudienceErrorWithCode:RTLeaveAudienceErrorReelNotFound];
        [self.delegate leaveAudienceFailedForReelId:reelId withError:error];
    }
}

- (NoArgsCallback)leaveAudienceSuccessCallbackForReelId:(NSNumber *)reelId {
    return ^{
        [self.delegate leaveAudienceSucceededForReelId:reelId];
    };
}

- (ErrorCallback)leaveAudienceFailureCallbackForReelId:(NSNumber *)reelId {
    return ^(NSError *error) {
        [self.delegate leaveAudienceFailedForReelId:reelId withError:error];
    };
}

@end
