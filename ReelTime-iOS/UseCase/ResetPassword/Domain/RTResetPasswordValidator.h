#import <Foundation/Foundation.h>

@interface RTResetPasswordValidator : NSObject

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
         newPassword:(NSString *)newPassword
              errors:(NSArray *__autoreleasing *)errors;

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
         newPassword:(NSString *)newPassword
       newClientName:(NSString *)newClientName
              errors:(NSArray *__autoreleasing *)errors;

@end
