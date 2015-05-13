#import <Foundation/Foundation.h>

@class RTClientCredentials;

@interface RTResetPasswordDataManager : NSObject

- (void)submitRequestForResetPasswordEmailWithCallback:(void (^)())callback;

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                 clientCredentials:(RTClientCredentials *)clientCredentials
                          withCode:(NSString *)code
                          callback:(void (^)())callback;

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                          withCode:(NSString *)code
   registerNewClientWithClientName:(NSString *)clientName
                          callback:(void (^)(RTClientCredentials *clientCredentials))callback;

@end
