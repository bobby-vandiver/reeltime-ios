#import "RTDeleteReelPresenter.h"

#import "RTDeleteReelView.h"
#import "RTDeleteReelInteractor.h"
#import "RTDeleteReelError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTDeleteReelErrorCodeToErrorMessageMapping.h"

@interface RTDeleteReelPresenter ()

@property id<RTDeleteReelView> view;
@property RTDeleteReelInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTDeleteReelPresenter

- (instancetype)initWithView:(id<RTDeleteReelView>)view
                  interactor:(RTDeleteReelInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTDeleteReelErrorCodeToErrorMessageMapping *mapping = [[RTDeleteReelErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedReelDeletionForReelId:(NSNumber *)reelId {
    [self.interactor deleteReelWithReelId:reelId];
}

- (void)deleteReelSucceededForReelId:(NSNumber *)reelId {
    [self.view showReelAsDeletedForReelId:reelId];
}

- (void)deleteReelFailedForReelId:(NSNumber *)reelId
                        withError:(NSError *)error {
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
