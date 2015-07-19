#import <Foundation/Foundation.h>

@protocol RTJoinAudienceView;

@interface RTJoinAudiencePresenter : NSObject

- (instancetype)initWithView:(id<RTJoinAudienceView>)view;

- (void)requestedAudienceMembershipForReelId:(NSNumber *)reelId;

@end
