#import <Foundation/Foundation.h>

#import "RTLeaveAudienceInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTLeaveAudienceView;
@class RTLeaveAudienceInteractor;

@interface RTLeaveAudiencePresenter : NSObject <RTLeaveAudienceInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTLeaveAudienceView>)view
                  interactor:(RTLeaveAudienceInteractor *)interactor;

- (void)requestedAudienceMembershipLeaveForReelId:(NSNumber *)reelId;

@end
