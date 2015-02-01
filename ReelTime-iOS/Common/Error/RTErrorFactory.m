#import "RTErrorFactory.h"
#import "NSError+RTError.h"

@implementation RTErrorFactory

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

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationErrors)code {
    return [NSError errorWithDomain:RTAccountRegistrationErrorDomain
                               code:code
                           userInfo:nil];
}

+ (NSError *)keyChainErrorWithCode:(RTKeyChainErrors)code
                     originalError:(NSError *)error {
    return [NSError errorWithDomain:RTKeyChainWrapperErrorDomain
                               code:code
                           userInfo:nil
                      originalError:error];
}

@end
