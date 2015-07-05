#import <Foundation/Foundation.h>

#import "RTAccountRegistrationError.h"
#import "RTConfirmAccountError.h"
#import "RTChangeDisplayNameError.h"
#import "RTChangePasswordError.h"
#import "RTDeviceRegistrationError.h"
#import "RTKeyChainError.h"
#import "RTLoginError.h"
#import "RTLogoutError.h"
#import "RTPagedListError.h"
#import "RTResetPasswordError.h"
#import "RTRevokeClientError.h"
#import "RTUserSummaryError.h"

@interface RTErrorFactory : NSObject

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationError)code;

+ (NSError *)confirmAccountErrorWithCode:(RTConfirmAccountError)code;

+ (NSError *)changeDisplayNameErrorWithCode:(RTChangeDisplayNameError)code;

+ (NSError *)changePasswordErrorWithCode:(RTChangePasswordError)code;

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code;

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code
                               originalError:(NSError *)error;

+ (NSError *)keyChainErrorWithCode:(RTKeyChainError)code
                     originalError:(NSError *)error;

+ (NSError *)loginErrorWithCode:(RTLoginError)code;

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error;

+ (NSError *)logoutErrorWithCode:(RTLogoutError)code;

+ (NSError *)logoutErrorWithCode:(RTLogoutError)code
                   originalError:(NSError *)error;

+ (NSError *)pagedListErrorWithCode:(RTPagedListError)code;

+ (NSError *)resetPasswordErrorWithCode:(RTResetPasswordError)code;

+ (NSError *)revokeClientErrorWithCode:(RTRevokeClientError)code;

+ (NSError *)userSummaryErrorWithCode:(RTUserSummaryError)code;

@end
