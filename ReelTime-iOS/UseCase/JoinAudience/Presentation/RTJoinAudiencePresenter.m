#import "RTJoinAudiencePresenter.h"
#import "RTJoinAudienceView.h"

@interface RTJoinAudiencePresenter ()

@property id<RTJoinAudienceView> view;

@end

@implementation RTJoinAudiencePresenter

- (instancetype)initWithView:(id<RTJoinAudienceView>)view {
    self = [super init];
    if (self) {
        self.view = view;
    }
    return self;
}

- (void)requestedAudienceMembershipForReelId:(NSNumber *)reelId {
    
}

@end
