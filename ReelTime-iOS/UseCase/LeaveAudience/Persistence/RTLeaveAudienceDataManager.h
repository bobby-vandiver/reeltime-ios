#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTLeaveAudienceDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)requestAudienceLeaveForReelId:(NSNumber *)reelId
                         leaveSuccess:(NoArgsCallback)leaveSuccess
                         leaveFailure:(ErrorCallback)leaveFailure;

@end
