#import <Foundation/Foundation.h>
#import "RTJoinAudienceInteractorDelegate.h"

@protocol RTJoinAudienceView;
@class RTJoinAudienceInteractor;

@interface RTJoinAudiencePresenter : NSObject <RTJoinAudienceInteractorDelegate>

- (instancetype)initWithView:(id<RTJoinAudienceView>)view
                  interactor:(RTJoinAudienceInteractor *)interactor;

- (void)requestedAudienceMembershipForReelId:(NSNumber *)reelId;

@end
