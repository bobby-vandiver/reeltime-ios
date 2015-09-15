#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTRemoveVideoFromReelDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)removeVideoForVideoId:(NSUInteger)videoId
            fromReelForReelId:(NSUInteger)reelId
                      success:(NoArgsCallback)success
                      failure:(ErrorCallback)failure;

@end
