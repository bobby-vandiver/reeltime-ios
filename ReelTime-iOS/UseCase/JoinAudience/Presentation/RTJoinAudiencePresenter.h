#import <Foundation/Foundation.h>

#import "RTJoinAudienceInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTJoinAudienceView;
@class RTJoinAudienceInteractor;

@interface RTJoinAudiencePresenter : NSObject <RTJoinAudienceInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTJoinAudienceView>)view
                  interactor:(RTJoinAudienceInteractor *)interactor;

- (void)requestedAudienceMembershipForReelId:(NSNumber *)reelId;

@end
