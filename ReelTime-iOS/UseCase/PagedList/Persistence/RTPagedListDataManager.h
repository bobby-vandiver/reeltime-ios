#import <Foundation/Foundation.h>

@class RTClient;

@interface RTPagedListDataManager : NSObject

@property (readonly) RTClient *client;

- (instancetype)initWithClient:(RTClient *)client;

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(id listPage))callback;

@end
