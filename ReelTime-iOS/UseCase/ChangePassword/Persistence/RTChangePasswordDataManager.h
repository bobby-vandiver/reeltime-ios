#import <Foundation/Foundation.h>
#import "RTCallback.h"

@protocol RTChangePasswordDataManagerDelegate;
@class RTClient;

@interface RTChangePasswordDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTChangePasswordDataManagerDelegate>)delegate
                          client:(RTClient *)client;

- (void)changePassword:(NSString *)password
              callback:(NoArgsCallback)callback;

@end
