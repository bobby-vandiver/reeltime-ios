#import "RTSynchronizedMutableArray.h"

@implementation RTSynchronizedMutableArray

- (NSUInteger)count {
    NSUInteger count = 0;
    @synchronized(self) {
        count = [super count];
    }
    return count;
}

- (id)objectAtIndex:(NSUInteger)index {
    id object;
    @synchronized(self) {
        object = [super objectAtIndex:index];
    }
    return object;
}

- (void)insertObject:(id)anObject
             atIndex:(NSUInteger)index {
    @synchronized(self) {
        [super insertObject:anObject atIndex:index];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    @synchronized(self) {
        [super removeObjectAtIndex:index];
    }
}

- (void)addObject:(id)anObject {
    @synchronized(self) {
        [super addObject:anObject];
    }
}

- (void)removeLastObject {
    @synchronized(self) {
        [super removeLastObject];
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    @synchronized(self) {
        [super replaceObjectAtIndex:index withObject:anObject];
    }
}

@end
