#import "RTErrorFactory.h"
#import "NSError+RTError.h"

@implementation RTErrorFactory

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationError)code {
    return [self errorWithDomain:RTAccountRegistrationErrorDomain code:code];
}

+ (NSError *)confirmAccountErrorWithCode:(RTConfirmAccountError)code {
    return [self errorWithDomain:RTConfirmAccountErrorDomain code:code];
}

+ (NSError *)changeDisplayNameWithCode:(RTChangeDisplayNameError)code {
    return [self errorWithDomain:RTChangeDisplayNameErrorDomain code:code];
}

+ (NSError *)changePasswordErrorWithCode:(RTChangePasswordError)code {
    return [self errorWithDomain:RTChangePasswordErrorDomain code:code];
}

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code {
    return [self errorWithDomain:RTDeviceRegistrationErrorDomain code:code];
}

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code
                               originalError:(NSError *)error {
    return [self errorWithDomain:RTDeviceRegistrationErrorDomain code:code originalError:error];
}

+ (NSError *)keyChainErrorWithCode:(RTKeyChainError)code
                     originalError:(NSError *)error {
    return [self errorWithDomain:RTKeyChainWrapperErrorDomain code:code originalError:error];
}

+ (NSError *)loginErrorWithCode:(RTLoginError)code {
    return [self loginErrorWithCode:code originalError:nil];
}

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error {
    return [self errorWithDomain:RTLoginErrorDomain code:code originalError:error];
}

+ (NSError *)pagedListErrorWithCode:(RTPagedListError)code {
    return [self errorWithDomain:RTPagedListErrorDomain code:code];
}

+ (NSError *)resetPasswordErrorWithCode:(RTResetPasswordError)code {
    return [self errorWithDomain:RTResetPasswordErrorDomain code:code];
}

+ (NSError *)userSummaryErrorWithCode:(RTUserSummaryError)code {
    return [self errorWithDomain:RTUserSummaryErrorDomain code:code];
}

+ (NSError *)errorWithDomain:(NSString *)domain
                        code:(NSInteger)code {

    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:nil];
}

+ (NSError *)errorWithDomain:(NSString *)domain
                        code:(NSInteger)code
               originalError:(NSError *)error {
    
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:nil
                      originalError:error];
}
    

@end
