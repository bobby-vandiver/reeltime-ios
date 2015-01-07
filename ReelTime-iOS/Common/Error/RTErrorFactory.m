#import "RTErrorFactory.h"
#import "NSError+RTError.h"

@implementation RTErrorFactory

+ (NSError *)loginErrorWithCode:(RTLoginErrors)code {
    return [self loginErrorWithCode:code
                      originalError:nil];
}

+ (NSError *)loginErrorWithCode:(RTLoginErrors)code
                  originalError:(NSError *)error {
    return [NSError errorWithDomain:RTLoginErrorDomain
                               code:code
                           userInfo:nil
                      originalError:error];
}

+ (NSError *)keyChainErrorWithCode:(RTKeyChainErrors)code
                     originalError:(NSError *)error {
    return [NSError errorWithDomain:RTKeyChainWrapperErrorDomain
                               code:code
                           userInfo:nil
                      originalError:error];
}

+ (NSError *)clientTokenErrorWithCode:(RTClientTokenErrors)code {
    return [NSError errorWithDomain:RTClientTokenErrorDomain
                               code:code
                           userInfo:nil];
}

@end
