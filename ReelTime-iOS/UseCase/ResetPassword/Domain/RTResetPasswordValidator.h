#import "RTValidator.h"

@interface RTResetPasswordValidator : RTValidator

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
            password:(NSString *)password
confirmationPassword:(NSString *)confirmationPassword
              errors:(NSArray *__autoreleasing *)errors;

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
            password:(NSString *)password
confirmationPassword:(NSString *)confirmationPassword
          clientName:(NSString *)clientName
              errors:(NSArray *__autoreleasing *)errors;

@end
