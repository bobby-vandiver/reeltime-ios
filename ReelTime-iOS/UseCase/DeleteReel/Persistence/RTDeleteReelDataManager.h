#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTDeleteReelDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)deleteReelWithReelId:(NSUInteger)reelId
                     success:(NoArgsCallback)success
                     failure:(ErrorCallback)failure;

@end
