#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTClient;

@interface RTChangeDisplayNameDataManager : NSObject

- (instancetype)initWithClient:(RTClient *)client;

- (void)changeDisplayName:(NSString *)displayName
                  changed:(NoArgsCallback)changed
               notChanged:(ArrayCallback)notChanged;

@end
