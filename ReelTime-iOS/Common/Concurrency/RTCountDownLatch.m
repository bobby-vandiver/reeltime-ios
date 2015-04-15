#import "RTCountDownLatch.h"
#import "RTLogging.h"

@interface RTCountDownLatch ()

@property (readwrite) NSUInteger count;
@property NSLock *mutex;
@property dispatch_semaphore_t semaphore;

@end

@implementation RTCountDownLatch

- (instancetype)initWithCount:(NSUInteger)count {
    self = [super init];
    if (self) {
        self.count = count;
        self.mutex = [[NSLock alloc] init];
        self.semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)countDown {
    [self.mutex lock];
    self.count--;
    
    BOOL shouldSignal = (self.count == 0);
    [self.mutex unlock];
    
    if (shouldSignal) {
        dispatch_semaphore_signal(self.semaphore);
    }
}
- (void)awaitExecutionOnQueue:(dispatch_queue_t)queue
                 withCallback:(void (^)())callback {
    
    dispatch_queue_t waitQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(waitQueue, ^{
        DDLogDebug(@"Waiting for countdown");
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);

        DDLogDebug(@"Countdown finished");
        dispatch_async(queue, ^{
            callback();
        });
    });
}

@end
