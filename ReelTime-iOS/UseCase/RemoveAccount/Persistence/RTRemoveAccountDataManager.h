#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTRemoveAccountDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)removeAccount:(NoArgsCallback)success
              failure:(ErrorCallback)failure;

@end
