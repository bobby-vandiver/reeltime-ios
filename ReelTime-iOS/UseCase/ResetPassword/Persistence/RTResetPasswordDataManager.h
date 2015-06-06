#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;
@class RTClientCredentials;

@interface RTResetPasswordDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)submitRequestForResetPasswordEmailForUsername:(NSString *)username
                                            emailSent:(NoArgsCallback)emailSent
                                          emailFailed:(ArrayCallback)emailFailed;

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                 clientCredentials:(RTClientCredentials *)clientCredentials
                          withCode:(NSString *)code
              passwordResetSuccess:(NoArgsCallback)success
                           failure:(ArrayCallback)failure;

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                          withCode:(NSString *)code
   registerNewClientWithClientName:(NSString *)clientName
              passwordResetSuccess:(ClientCredentialsCallback)success
                           failure:(ArrayCallback)failure;

@end
