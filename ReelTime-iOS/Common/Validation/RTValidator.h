#import <Foundation/Foundation.h>

@interface RTValidator : NSObject

- (BOOL)validateWithErrors:(NSArray *__autoreleasing *)errors
           validationBlock:(void (^)(NSMutableArray *errorContainer))validationBlock;

@end
