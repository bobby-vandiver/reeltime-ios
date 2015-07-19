#import "RTJoinAudiencePresenter.h"

#import "RTJoinAudienceView.h"
#import "RTJoinAudienceInteractor.h"

@interface RTJoinAudiencePresenter ()

@property id<RTJoinAudienceView> view;
@property RTJoinAudienceInteractor *interactor;

@end

@implementation RTJoinAudiencePresenter

- (instancetype)initWithView:(id<RTJoinAudienceView>)view
                  interactor:(RTJoinAudienceInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedAudienceMembershipForReelId:(NSNumber *)reelId {
    [self.interactor joinAudienceForReelId:reelId];
}

- (void)joinAudienceSucceedForReelId:(NSNumber *)reelId {
    
}

- (void)joinAudienceFailedForReelId:(NSNumber *)reelId
                          withError:(NSError *)error {
    
}

@end
