#import <Foundation/Foundation.h>

@protocol RTLeaveAudienceInteractorDelegate;
@class RTLeaveAudienceDataManager;

@interface RTLeaveAudienceInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTLeaveAudienceInteractorDelegate>)delegate
                     dataManager:(RTLeaveAudienceDataManager *)dataManager;

- (void)leaveAudienceForReelId:(NSNumber *)reelId;

@end
