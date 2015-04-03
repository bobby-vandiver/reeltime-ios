#import <Foundation/Foundation.h>

@interface RTCountDownLatch : NSObject

@property (readonly) NSUInteger count;

- (instancetype)initWithCount:(NSUInteger)count;

- (void)countDown;

- (void)awaitWithCallback:(void (^)())callback;

@end
