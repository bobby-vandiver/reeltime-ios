#import <Foundation/Foundation.h>

@protocol RTJoinAudienceInteractorDelegate;
@class RTJoinAudienceDataManager;

@interface RTJoinAudienceInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTJoinAudienceInteractorDelegate>)delegate
                     dataManager:(RTJoinAudienceDataManager *)dataManager;

- (void)joinAudienceForReelId:(NSNumber *)reelId;

@end
