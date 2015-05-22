#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTClient;

@interface RTChangePasswordDataManager : NSObject

- (instancetype)initWithClient:(RTClient *)client;

- (void)changePassword:(NSString *)password
               changed:(NoArgsCallback)changed
            notChanged:(ArrayCallback)notChanged;

@end
