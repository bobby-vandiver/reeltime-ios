#import <Foundation/Foundation.h>

@protocol RTRemoveVideoFromReelInteractorDelegate;
@class RTRemoveVideoFromReelDataManager;

@interface RTRemoveVideoFromReelInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTRemoveVideoFromReelInteractorDelegate>)delegate
                     dataManager:(RTRemoveVideoFromReelDataManager *)dataManager;

- (void)removeVideoWithVideoId:(NSNumber *)videoId
            fromReelWithReelId:(NSNumber *)reelId;

@end
