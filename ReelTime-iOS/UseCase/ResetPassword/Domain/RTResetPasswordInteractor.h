#import <Foundation/Foundation.h>

@interface RTResetPasswordInteractor : NSObject

- (void)requestResetPasswordEmailForUsername:(NSString *)username;

- (void)resetPasswordForCurrentClientWithCode:(NSString *)code
                                     username:(NSString *)username
                                  newPassword:(NSString *)newPassword;

- (void)resetPasswordForNewClientWithClientName:(NSString *)clientName
                                           code:(NSString *)code
                                       username:(NSString *)username
                                    newPassword:(NSString *)newPassword;

@end
