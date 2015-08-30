#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTAddVideoToReelDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)addVideoForVideoId:(NSUInteger)videoId
           toReelForReelId:(NSUInteger)reelId
                   success:(NoArgsCallback)success
                   failure:(ErrorCallback)failure;

@end
