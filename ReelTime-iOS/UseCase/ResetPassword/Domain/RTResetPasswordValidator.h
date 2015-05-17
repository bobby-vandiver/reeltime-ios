#import <Foundation/Foundation.h>

@interface RTResetPasswordValidator : NSObject

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
            password:(NSString *)password
              errors:(NSArray *__autoreleasing *)errors;

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
            password:(NSString *)password
          clientName:(NSString *)clientName
              errors:(NSArray *__autoreleasing *)errors;

@end
