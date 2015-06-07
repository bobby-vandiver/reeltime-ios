#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTRevokeClientDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)revokeClientWithClientId:(NSString *)clientId
               revocationSuccees:(NoArgsCallback)success
                         failure:(ArrayCallback)failure;

@end
