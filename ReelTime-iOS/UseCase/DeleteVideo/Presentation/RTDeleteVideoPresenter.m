#import "RTDeleteVideoPresenter.h"

#import "RTDeleteVideoView.h"
#import "RTDeleteVideoInteractor.h"
#import "RTDeleteVideoError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTDeleteVideoErrorCodeToErrorMessageMapping.h"

@interface RTDeleteVideoPresenter ()

@property id<RTDeleteVideoView> view;
@property RTDeleteVideoInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTDeleteVideoPresenter

- (instancetype)initWithView:(id<RTDeleteVideoView>)view
                  interactor:(RTDeleteVideoInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTDeleteVideoErrorCodeToErrorMessageMapping *mapping = [[RTDeleteVideoErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
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
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
