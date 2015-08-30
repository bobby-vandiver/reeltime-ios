#import "RTAddVideoToReelInteractor.h"

#import "RTAddVideoToReelInteractorDelegate.h"
#import "RTAddVideoToReelDataManager.h"

#import "RTAddVideoToReelError.h"
#import "RTErrorFactory.h"

@interface RTAddVideoToReelInteractor ()

@property id<RTAddVideoToReelInteractorDelegate> delegate;
@property RTAddVideoToReelDataManager *dataManager;

@end

@implementation RTAddVideoToReelInteractor

- (instancetype)initWithDelegate:(id<RTAddVideoToReelInteractorDelegate>)delegate
                     dataManager:(RTAddVideoToReelDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)addVideoWithVideoId:(NSNumber *)videoId
           toReelWithReelId:(NSNumber *)reelId {

    if (videoId != nil && reelId != nil) {
        [self.dataManager addVideoForVideoId:[videoId integerValue]
                             toReelForReelId:[reelId integerValue]
                                     success:[self addVideoToReelSuccessCallbackWithVideoId:videoId reelId:reelId]
                                     failure:[self addVideoToReelFailureCallbackWithVideoId:videoId reelId:reelId]];
    }
    else if (videoId == nil) {
        NSError *error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorVideoNotFound];
        [self.delegate addVideoToReelFailedForVideoId:videoId reelId:reelId withError:error];
    }
    else if (reelId == nil) {
        NSError *error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorReelNotFound];
        [self.delegate addVideoToReelFailedForVideoId:videoId reelId:reelId withError:error];
    }
}

- (NoArgsCallback)addVideoToReelSuccessCallbackWithVideoId:(NSNumber *)videoId
                                                    reelId:(NSNumber *)reelId {
    return ^{
        [self.delegate addVideoToReelSucceededForVideoId:videoId reelId:reelId];
    };
}

- (ErrorCallback)addVideoToReelFailureCallbackWithVideoId:(NSNumber *)videoId
                                                   reelId:(NSNumber *)reelId {
    return ^(NSError *error) {
        [self.delegate addVideoToReelFailedForVideoId:videoId reelId:reelId withError:error];
    };
}

@end
