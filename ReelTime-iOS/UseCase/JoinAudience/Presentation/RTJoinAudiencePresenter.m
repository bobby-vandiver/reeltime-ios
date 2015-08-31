#import "RTJoinAudiencePresenter.h"

#import "RTJoinAudienceView.h"
#import "RTJoinAudienceInteractor.h"
#import "RTJoinAudienceError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTJoinAudienceErrorCodeToErrorMessageMapping.h"

#import "RTLogging.h"

@interface RTJoinAudiencePresenter ()

@property id<RTJoinAudienceView> view;
@property RTJoinAudienceInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTJoinAudiencePresenter

- (instancetype)initWithView:(id<RTJoinAudienceView>)view
                  interactor:(RTJoinAudienceInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTJoinAudienceErrorCodeToErrorMessageMapping *mapping = [[RTJoinAudienceErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedAudienceMembershipForReelId:(NSNumber *)reelId {
    [self.interactor joinAudienceForReelId:reelId];
}

- (void)joinAudienceSucceededForReelId:(NSNumber *)reelId {
    [self.view showAudienceAsJoinedForReelId:reelId];
}

- (void)joinAudienceFailedForReelId:(NSNumber *)reelId
                          withError:(NSError *)error {
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
