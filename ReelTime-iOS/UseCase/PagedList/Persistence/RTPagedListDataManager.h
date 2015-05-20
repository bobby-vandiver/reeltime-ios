#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTClient;

@interface RTPagedListDataManager : NSObject

@property (readonly) RTClient *client;

- (instancetype)initWithClient:(RTClient *)client;

- (void)retrievePage:(NSUInteger)page
            callback:(ArrayCallback)callback;

@end
