#import <Foundation/Foundation.h>

#import "RTAccountRegistrationError.h"
#import "RTConfirmAccountError.h"
#import "RTChangeDisplayNameError.h"
#import "RTChangePasswordError.h"
#import "RTDeviceRegistrationError.h"
#import "RTKeyChainError.h"
#import "RTLoginError.h"
#import "RTPagedListError.h"
#import "RTResetPasswordError.h"
#import "RTUserSummaryError.h"

@interface RTErrorFactory : NSObject

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationError)code;

+ (NSError *)confirmAccountErrorWithCode:(RTConfirmAccountError)code;

// TODO: Fix name -- include "Error"
+ (NSError *)changeDisplayNameWithCode:(RTChangeDisplayNameError)code;

+ (NSError *)changePasswordErrorWithCode:(RTChangePasswordError)code;

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code;

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code
                               originalError:(NSError *)error;

+ (NSError *)keyChainErrorWithCode:(RTKeyChainError)code
                     originalError:(NSError *)error;

+ (NSError *)loginErrorWithCode:(RTLoginError)code;

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error;

+ (NSError *)pagedListErrorWithCode:(RTPagedListError)code;

+ (NSError *)resetPasswordErrorWithCode:(RTResetPasswordError)code;

+ (NSError *)userSummaryErrorWithCode:(RTUserSummaryError)code;

@end
