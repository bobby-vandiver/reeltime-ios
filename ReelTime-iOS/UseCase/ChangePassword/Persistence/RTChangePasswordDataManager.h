#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTChangePasswordDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)changePassword:(NSString *)password
               changed:(NoArgsCallback)changed
            notChanged:(ArrayCallback)notChanged;

@end
