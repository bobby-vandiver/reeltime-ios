#import "RTErrorFactory.h"
#import "NSError+RTError.h"

@implementation RTErrorFactory

+ (NSError *)loginErrorWithCode:(RTLoginErrors)code {
    return [NSError errorWithDomain:RTLoginErrorDomain
                               code:code
                           userInfo:nil
                      originalError:nil];
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
