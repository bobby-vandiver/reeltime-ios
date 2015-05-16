#import <Foundation/Foundation.h>

@protocol RTResetPasswordInteractorDelegate;
@class RTResetPasswordDataManager;

@class RTCurrentUserService;
@class RTClientCredentialsService;

@interface RTResetPasswordInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTResetPasswordInteractorDelegate>)delegate
                     dataManager:(RTResetPasswordDataManager *)dataManager
              currentUserService:(RTCurrentUserService *)currentUserService
        clientCredentialsService:(RTClientCredentialsService *)clientCredentialsService;

- (void)sendResetPasswordEmailForUsername:(NSString *)username;

- (void)resetPasswordForCurrentClientWithCode:(NSString *)code
                                     username:(NSString *)username
                                  newPassword:(NSString *)newPassword;

- (void)resetPasswordForNewClientWithClientName:(NSString *)clientName
                                           code:(NSString *)code
                                       username:(NSString *)username
                                    newPassword:(NSString *)newPassword;

@end
