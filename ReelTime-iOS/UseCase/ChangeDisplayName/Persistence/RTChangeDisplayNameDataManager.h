#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTAPIClient;

@interface RTChangeDisplayNameDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)changeDisplayName:(NSString *)displayName
                  changed:(NoArgsCallback)changed
               notChanged:(ArrayCallback)notChanged;

@end
