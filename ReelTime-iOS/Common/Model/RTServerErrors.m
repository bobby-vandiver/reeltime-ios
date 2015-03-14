#import "RTServerErrors.h"

@implementation RTServerErrors

- (NSString *)description {
    NSUInteger count = self.errors.count;
    NSMutableString *description = [NSMutableString stringWithFormat:@"errors(%lu): [", count];

    for (NSUInteger idx = 0; idx < count; idx++) {
        [description appendString:self.errors[idx]];
        
        if (idx != (count - 1)) {
            [description appendString:@", "];
        }
    }
    
    [description appendString:@"]"];
    return description;
}

@end
