#import <Foundation/Foundation.h>
#import "RTLeaveAudienceInteractorDelegate.h"

@protocol RTLeaveAudienceView;
@class RTLeaveAudienceInteractor;

@interface RTLeaveAudiencePresenter : NSObject <RTLeaveAudienceInteractorDelegate>

- (instancetype)initWithView:(id<RTLeaveAudienceView>)view
                  interactor:(RTLeaveAudienceInteractor *)interactor;

- (void)requestedAudienceMembershipLeaveForReelId:(NSNumber *)reelId;

@end
