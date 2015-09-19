#import "RTRemoveVideoFromReelPresenter.h"

#import "RTRemoveVideoFromReelView.h"
#import "RTRemoveVideoFromReelInteractor.h"
#import "RTRemoveVideoFromReelError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTRemoveVideoFromReelErrorCodeToErrorMessageMapping.h"

@interface RTRemoveVideoFromReelPresenter ()

@property id<RTRemoveVideoFromReelView> view;
@property RTRemoveVideoFromReelInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTRemoveVideoFromReelPresenter

- (instancetype)initWithView:(id<RTRemoveVideoFromReelView>)view
                  interactor:(RTRemoveVideoFromReelInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTRemoveVideoFromReelErrorCodeToErrorMessageMapping *mapping = [[RTRemoveVideoFromReelErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedVideoRemovalFromReelForVideoId:(NSNumber *)videoId
                                         reelId:(NSNumber *)reelId {
    [self.interactor removeVideoWithVideoId:videoId fromReelWithReelId:reelId];
}

- (void)removeVideoFromReelSucceededForVideoId:(NSNumber *)videoId
                                        reelId:(NSNumber *)reelId {
    [self.view showVideoAsRemovedFromReelForVideoId:videoId reelId:reelId];
}

- (void)removeVideoFromReelFailedForVideoId:(NSNumber *)videoId
                                     reelId:(NSNumber *)reelId
                                  withError:(NSError *)error {
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
