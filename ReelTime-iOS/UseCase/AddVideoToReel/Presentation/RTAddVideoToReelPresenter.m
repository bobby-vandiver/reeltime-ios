#import "RTAddVideoToReelPresenter.h"

#import "RTAddVideoToReelView.h"
#import "RTAddVideoToReelInteractor.h"
#import "RTAddVideoToReelError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTAddVideoToReelErrorCodeToErrorMessageMapping.h"

#import "RTLogging.h"

@interface RTAddVideoToReelPresenter ()

@property id<RTAddVideoToReelView> view;
@property RTAddVideoToReelInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTAddVideoToReelPresenter

- (instancetype)initWithView:(id<RTAddVideoToReelView>)view
                  interactor:(RTAddVideoToReelInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTAddVideoToReelErrorCodeToErrorMessageMapping *mapping = [[RTAddVideoToReelErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedVideoAdditionForVideoId:(NSNumber *)videoId
                         toReelForReelId:(NSNumber *)reelId {
    [self.interactor addVideoWithVideoId:videoId toReelWithReelId:reelId];
}

- (void)addVideoToReelSucceededForVideoId:(NSNumber *)videoId
                                   reelId:(NSNumber *)reelId {
    [self.view showVideoAsAddedToReelForVideoId:videoId reelId:reelId];
}

- (void)addVideoToReelFailedForVideoId:(NSNumber *)videoId
                                reelId:(NSNumber *)reelId
                             withError:(NSError *)error {
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
