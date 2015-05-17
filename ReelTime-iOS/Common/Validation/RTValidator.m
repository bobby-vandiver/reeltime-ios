#import "RTValidator.h"

@implementation RTValidator

- (BOOL)validateWithErrors:(NSArray *__autoreleasing *)errors
           validationBlock:(void (^)(NSMutableArray *errorContainer))validationBlock {
    BOOL valid = YES;

    NSMutableArray *errorContainer = [NSMutableArray array];
    validationBlock(errorContainer);
    
    if (errorContainer.count > 0) {
        valid = NO;
        
        if (errors) {
            *errors = errorContainer;
        }
    }
    
    return valid;
}

@end
