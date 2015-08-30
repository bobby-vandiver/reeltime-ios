#import "RTDeleteVideoInteractor.h"

#import "RTDeleteVideoInteractorDelegate.h"
#import "RTDeleteVideoDataManager.h"

#import "RTDeleteVideoError.h"
#import "RTErrorFactory.h"

@interface RTDeleteVideoInteractor ()

@property id<RTDeleteVideoInteractorDelegate> delegate;
@property RTDeleteVideoDataManager *dataManager;

@end

@implementation RTDeleteVideoInteractor

- (instancetype)initWithDelegate:(id<RTDeleteVideoInteractorDelegate>)delegate
                     dataManager:(RTDeleteVideoDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)deleteVideoWithVideoId:(NSNumber *)videoId {
    if (videoId != nil) {
        [self.dataManager deleteVideoForVideoId:[videoId integerValue]
                                        success:[self deleteVideoSuccessCallbackWithVideoId:videoId]
                                        failure:[self deleteVideoFailureCallbackWithVideoId:videoId]];
    }
    else {
        NSError *error = [RTErrorFactory deleteVideoErrorWithCode:RTDeleteVideoErrorVideoNotFound];
        [self.delegate deleteVideoFailedForVideoId:videoId withError:error];
    }
}

- (NoArgsCallback)deleteVideoSuccessCallbackWithVideoId:(NSNumber *)videoId {
    return ^{
        [self.delegate deleteVideoSucceededForVideoId:videoId];
    };
}

- (ErrorCallback)deleteVideoFailureCallbackWithVideoId:(NSNumber *)videoId {
    return ^(NSError *error) {
        [self.delegate deleteVideoFailedForVideoId:videoId withError:error];
    };
}

@end
