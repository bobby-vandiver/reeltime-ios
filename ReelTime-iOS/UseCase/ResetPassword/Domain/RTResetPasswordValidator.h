#import <Foundation/Foundation.h>

@interface RTResetPasswordValidator : NSObject

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
         newPassword:(NSString *)newPassword
              errors:(NSArray *__autoreleasing *)errors;

@end
