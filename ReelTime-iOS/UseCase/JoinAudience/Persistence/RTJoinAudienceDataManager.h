#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTJoinAudienceDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)requestAudienceMembershipForReelId:(NSNumber *)reelId
                               joinSuccess:(NoArgsCallback)success
                               joinFailure:(ErrorCallback)failure;

@end
