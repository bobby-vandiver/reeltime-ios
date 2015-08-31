#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTCreateReelDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)createReelForName:(NSString *)name
                  success:(NoArgsCallback)success
                  failure:(ErrorCallback)failure;
@end
