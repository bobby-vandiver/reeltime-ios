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

- (void)awaitWithCallback:(void (^)())callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(queue, ^{
        DDLogDebug(@"Waiting for countdown");
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);

        DDLogDebug(@"Countdown finished");
        callback();
    });
}

@end
