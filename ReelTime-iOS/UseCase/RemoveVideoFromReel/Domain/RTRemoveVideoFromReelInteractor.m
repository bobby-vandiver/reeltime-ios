#import "RTRemoveVideoFromReelInteractor.h"

#import "RTRemoveVideoFromReelInteractorDelegate.h"
#import "RTRemoveVideoFromReelDataManager.h"

#import "RTRemoveVideoFromReelError.h"
#import "RTErrorFactory.h"

@interface RTRemoveVideoFromReelInteractor ()

@property id<RTRemoveVideoFromReelInteractorDelegate> delegate;
@property RTRemoveVideoFromReelDataManager *dataManager;

@end

@implementation RTRemoveVideoFromReelInteractor

- (instancetype)initWithDelegate:(id<RTRemoveVideoFromReelInteractorDelegate>)delegate
                     dataManager:(RTRemoveVideoFromReelDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)removeVideoWithVideoId:(NSNumber *)videoId
            fromReelWithReelId:(NSNumber *)reelId {
    
    if (videoId != nil && reelId != nil) {
        [self.dataManager removeVideoForVideoId:[videoId integerValue]
                              fromReelForReelId:[reelId integerValue]
                                        success:[self removeVideoFromReelSuccessCallbackWithVideoId:videoId reelId:reelId]
                                        failure:[self removeVideoFromReelFailureCallbackWithVideoId:videoId reelId:reelId]];
    }
    else {
        RTRemoveVideoFromReelError code;
        
        if (videoId == nil) {
            code = RTRemoveVideoFromReelErrorVideoNotFound;
        }
        else if (reelId == nil) {
            code = RTRemoveVideoFromReelErrorReelNotFound;
        }
        
        NSError *error = [RTErrorFactory removeVideoFromReelErrorWithCode:code];
        [self.delegate removeVideoFromReelFailedForVideoId:videoId reelId:reelId withError:error];
    }
}

- (NoArgsCallback)removeVideoFromReelSuccessCallbackWithVideoId:(NSNumber *)videoId
                                                         reelId:(NSNumber *)reelId {
    return ^{
        [self.delegate removeVideoFromReelSucceededForVideoId:videoId reelId:reelId];
    };
}

- (ErrorCallback)removeVideoFromReelFailureCallbackWithVideoId:(NSNumber *)videoId
                                                        reelId:(NSNumber *)reelId {
    return ^(NSError *error) {
        [self.delegate removeVideoFromReelFailedForVideoId:videoId reelId:reelId withError:error];
    };
}

@end
