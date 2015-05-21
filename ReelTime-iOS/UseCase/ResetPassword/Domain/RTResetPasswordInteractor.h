#import <Foundation/Foundation.h>

@protocol RTResetPasswordInteractorDelegate;

@class RTResetPasswordDataManager;
@class RTResetPasswordValidator;

@class RTCurrentUserService;
@class RTClientCredentialsService;

@interface RTResetPasswordInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTResetPasswordInteractorDelegate>)delegate
                     dataManager:(RTResetPasswordDataManager *)dataManager
                       validator:(RTResetPasswordValidator *)validator
              currentUserService:(RTCurrentUserService *)currentUserService
        clientCredentialsService:(RTClientCredentialsService *)clientCredentialsService;

- (void)sendResetPasswordEmailForUsername:(NSString *)username;

- (void)resetPasswordForCurrentClientWithCode:(NSString *)code
                                     username:(NSString *)username
                                     password:(NSString *)password
                         confirmationPassword:(NSString *)confirmationPassword;

- (void)resetPasswordForNewClientWithClientName:(NSString *)clientName
                                           code:(NSString *)code
                                       username:(NSString *)username
                                       password:(NSString *)password
                           confirmationPassword:(NSString *)confirmationPassword;

@end
