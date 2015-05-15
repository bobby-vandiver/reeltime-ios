#import <Foundation/Foundation.h>

@protocol RTResetPasswordDataManagerDelegate;

@class RTClient;
@class RTClientCredentials;

@interface RTResetPasswordDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTResetPasswordDataManagerDelegate>)delegate
                          client:(RTClient *)client;

- (void)submitRequestForResetPasswordEmailForUsername:(NSString *)username
                                         withCallback:(void (^)())callback;

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
