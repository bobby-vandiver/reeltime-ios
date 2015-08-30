#import <Foundation/Foundation.h>

@protocol RTAddVideoToReelInteractorDelegate;
@class RTAddVideoToReelDataManager;

@interface RTAddVideoToReelInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTAddVideoToReelInteractorDelegate>)delegate
                     dataManager:(RTAddVideoToReelDataManager *)dataManager;

- (void)addVideoWithVideoId:(NSNumber *)videoId
           toReelWithReelId:(NSNumber *)reelId;

@end
