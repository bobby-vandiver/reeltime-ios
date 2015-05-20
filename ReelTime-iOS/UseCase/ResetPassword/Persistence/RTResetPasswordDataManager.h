#import <Foundation/Foundation.h>
#import "RTCallback.h"

@protocol RTResetPasswordDataManagerDelegate;

@class RTClient;
@class RTClientCredentials;

@interface RTResetPasswordDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTResetPasswordDataManagerDelegate>)delegate
                          client:(RTClient *)client;

- (void)submitRequestForResetPasswordEmailForUsername:(NSString *)username
                                         withCallback:(NoArgsCallback)callback;

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                 clientCredentials:(RTClientCredentials *)clientCredentials
                          withCode:(NSString *)code
                          callback:(NoArgsCallback)callback;

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                          withCode:(NSString *)code
   registerNewClientWithClientName:(NSString *)clientName
                          callback:(ClientCredentialsCallback)callback;

@end
