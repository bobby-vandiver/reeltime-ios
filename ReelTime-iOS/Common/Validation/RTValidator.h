#import <Foundation/Foundation.h>

@class RTPasswordValidationMapping;

@interface RTValidator : NSObject

- (BOOL)validateWithErrors:(NSArray *__autoreleasing *)errors
           validationBlock:(void (^)(NSMutableArray *errorContainer))validationBlock;

- (void)validatePassword:(NSString *)password
    confirmationPassword:(NSString *)confirmationPassword
             withMapping:(RTPasswordValidationMapping *)mapping
                  errors:(NSMutableArray *)errors;

- (void)validateDisplayName:(NSString *)displayName
                 withDomain:(NSString *)domain
                missingCode:(NSInteger)missingCode
                invalidCode:(NSInteger)invalidCode
                     errors:(NSMutableArray *)errors;

- (void)validateParameter:(NSString *)parameter
              withPattern:(NSString *)pattern
                   domain:(NSString *)domain
                     code:(NSInteger)code
                   errors:(NSMutableArray *)errors;

@end
