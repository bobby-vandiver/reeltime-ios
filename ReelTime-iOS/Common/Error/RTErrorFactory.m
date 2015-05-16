#import "RTErrorFactory.h"
#import "NSError+RTError.h"

@implementation RTErrorFactory

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationError)code {
    return [NSError errorWithDomain:RTAccountRegistrationErrorDomain
                               code:code
                           userInfo:nil];
}

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code {
    return [NSError errorWithDomain:RTDeviceRegistrationErrorDomain
                               code:code
                           userInfo:nil];
}

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code
                               originalError:(NSError *)error {
    return [NSError errorWithDomain:RTDeviceRegistrationErrorDomain
                               code:code
                           userInfo:nil
                      originalError:error];
}

+ (NSError *)keyChainErrorWithCode:(RTKeyChainError)code
                     originalError:(NSError *)error {
    return [NSError errorWithDomain:RTKeyChainWrapperErrorDomain
                               code:code
                           userInfo:nil
                      originalError:error];
}

+ (NSError *)loginErrorWithCode:(RTLoginError)code {
    return [self loginErrorWithCode:code
                      originalError:nil];
}

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error {
    return [NSError errorWithDomain:RTLoginErrorDomain
                               code:code
                           userInfo:nil
                      originalError:error];
}

+ (NSError *)pagedListErrorWithCode:(RTPagedListError)code {
    return [NSError errorWithDomain:RTPagedListErrorDomain
                               code:code
                           userInfo:nil];
}

+ (NSError *)resetPasswordErrorWithCode:(RTResetPasswordError)code {
    return [NSError errorWithDomain:RTResetPasswordErrorDomain
                               code:code
                           userInfo:nil];
}

+ (NSError *)userSummaryErrorWithCode:(RTUserSummaryError)code {
    return [NSError errorWithDomain:RTUserSummaryErrorDomain
                               code:code
                           userInfo:nil];
}

@end
