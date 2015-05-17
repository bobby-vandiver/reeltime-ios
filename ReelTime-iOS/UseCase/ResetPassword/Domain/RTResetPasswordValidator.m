#import "RTResetPasswordValidator.h"

@implementation RTResetPasswordValidator

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
         newPassword:(NSString *)newPassword
              errors:(NSArray *__autoreleasing *)errors {
    return NO;
}

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
         newPassword:(NSString *)newPassword
       newClientName:(NSString *)newClientName
              errors:(NSArray *__autoreleasing *)errors {
    return NO;
}

@end
