#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTDeleteVideoDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)deleteVideoForVideoId:(NSUInteger)videoId
                      success:(NoArgsCallback)success
                      failure:(ErrorCallback)failure;

@end
