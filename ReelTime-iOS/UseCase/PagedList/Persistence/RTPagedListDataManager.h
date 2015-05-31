#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTAPIClient;

@interface RTPagedListDataManager : NSObject

@property (readonly) RTAPIClient *client;

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)retrievePage:(NSUInteger)page
            callback:(ArrayCallback)callback;

@end
