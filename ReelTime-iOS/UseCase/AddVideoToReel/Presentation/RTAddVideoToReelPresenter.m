#import "RTAddVideoToReelPresenter.h"

#import "RTAddVideoToReelView.h"
#import "RTAddVideoToReelInteractor.h"
#import "RTAddVideoToReelError.h"

#import "RTLogging.h"

@interface RTAddVideoToReelPresenter ()

@property id<RTAddVideoToReelView> view;
@property RTAddVideoToReelInteractor *interactor;

@end

@implementation RTAddVideoToReelPresenter

- (instancetype)initWithView:(id<RTAddVideoToReelView>)view
                  interactor:(RTAddVideoToReelInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
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
    
    NSString *const unknownErrorMessage = @"Unknown error occurred while adding the video to the reel. Please try again.";
    
    if ([error.domain isEqual:RTAddVideoToReelErrorDomain]) {
        NSInteger code = error.code;
        
        if (code == RTAddVideoToReelErrorVideoNotFound) {
            [self.view showErrorMessage:@"Cannot add an unknown video to a reel!"];
        }
        else if (code == RTAddVideoToReelErrorReelNotFound) {
            [self.view showErrorMessage:@"Cannot add a video to an unknown reel!"];
        }
        else if (code == RTAddVideoToReelErrorUnauthorized) {
            [self.view showErrorMessage:@"You don't have permission to do that!"];
        }
        else if (code == RTAddVideoToReelErrorUnknownError) {
            [self.view showErrorMessage:unknownErrorMessage];
        }
    }
    else {
        DDLogWarn(@"Encountered an error outside the %@ domain = %@", RTAddVideoToReelErrorDomain, error);
        [self.view showErrorMessage:unknownErrorMessage];
    }
    
}

@end
