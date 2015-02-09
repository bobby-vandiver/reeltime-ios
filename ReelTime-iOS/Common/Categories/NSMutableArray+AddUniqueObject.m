#import "NSMutableArray+AddUniqueObject.h"

@implementation NSMutableArray (AddUniqueObject)

- (void)addUniqueObject:(id)obj {
    if (![self containsObject:obj]) {
        [self addObject:obj];
    }
}

@end