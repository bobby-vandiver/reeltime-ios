#import <Foundation/Foundation.h>

@class RTPasswordValidationMapping;

@interface RTValidator : NSObject

- (BOOL)validateWithErrors:(NSArray *__autoreleasing *)errors
           validationBlock:(void (^)(NSMutableArray *errorContainer))validationBlock;

- (void)validatePassword:(NSString *)password
    confirmationPassword:(NSString *)confirmationPassword
             withMapping:(RTPasswordValidationMapping *)mapping
                  errors:(NSMutableArray *)errors;

@end
