#import "RTSynchronizedMutableArray.h"

@interface RTSynchronizedMutableArray ()

@property NSMutableArray *objects;

@end

@implementation RTSynchronizedMutableArray

- (instancetype)init {
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray arrayWithCapacity:numItems];
    }
    return self;
}

- (NSUInteger)count {
    NSUInteger count = 0;
    @synchronized(self) {
        count = [self.objects count];
    }
    return count;
}

- (id)objectAtIndex:(NSUInteger)index {
    id object;
    @synchronized(self) {
        object = [self.objects objectAtIndex:index];
    }
    return object;
}

- (void)insertObject:(id)anObject
             atIndex:(NSUInteger)index {
    @synchronized(self) {
        [self.objects insertObject:anObject atIndex:index];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    @synchronized(self) {
        [self.objects removeObjectAtIndex:index];
    }
}

- (void)addObject:(id)anObject {
    @synchronized(self) {
        [self.objects addObject:anObject];
    }
}

- (void)removeLastObject {
    @synchronized(self) {
        [self.objects removeLastObject];
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    @synchronized(self) {
        [self.objects replaceObjectAtIndex:index withObject:anObject];
    }
}

@end
