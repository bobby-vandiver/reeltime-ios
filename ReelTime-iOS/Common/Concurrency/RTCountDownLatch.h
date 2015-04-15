#import <Foundation/Foundation.h>

@interface RTCountDownLatch : NSObject

@property (readonly) NSUInteger count;

- (instancetype)initWithCount:(NSUInteger)count;

- (void)countDown;

- (void)awaitExecutionOnQueue:(dispatch_queue_t)queue
                 withCallback:(void (^)())callback;

@end
