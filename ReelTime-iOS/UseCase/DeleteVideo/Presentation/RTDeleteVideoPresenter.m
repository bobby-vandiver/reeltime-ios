#import "RTDeleteVideoPresenter.h"

#import "RTDeleteVideoView.h"
#import "RTDeleteVideoInteractor.h"
#import "RTDeleteVideoError.h"

#import "RTLogging.h"

@interface RTDeleteVideoPresenter ()

@property id<RTDeleteVideoView> view;
@property RTDeleteVideoInteractor *interactor;

@end

@implementation RTDeleteVideoPresenter

- (instancetype)initWithView:(id<RTDeleteVideoView>)view
                  interactor:(RTDeleteVideoInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedVideoDeletionForVideoId:(NSNumber *)videoId {
    [self.interactor deleteVideoWithVideoId:videoId];
}

- (void)deleteVideoSucceededForVideoId:(NSNumber *)videoId {
    [self.view showVideoAsDeletedForVideoId:videoId];
}

- (void)deleteVideoFailedForVideoId:(NSNumber *)videoId
                          withError:(NSError *)error {
    
    NSString *const unknownErrorMessage = @"Unknown error occurred while deleting video. Please try again.";
    
    if ([error.domain isEqual:RTDeleteVideoErrorDomain]) {
        NSInteger code = error.code;
        
        if (code == RTDeleteVideoErrorVideoNotFound) {
            [self.view showErrorMessage:@"Cannot delete an unknown video!"];
        }
        else if (code == RTDeleteVideoErrorUnknownError) {
            [self.view showErrorMessage:unknownErrorMessage];
        }
    }
    else {
        DDLogWarn(@"Encountered an error outside the %@ domain = %@", RTDeleteVideoErrorDomain, error);
        [self.view showErrorMessage:unknownErrorMessage];
    }
}

@end
