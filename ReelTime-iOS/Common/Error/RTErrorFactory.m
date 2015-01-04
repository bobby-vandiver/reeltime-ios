#import "RTErrorFactory.h"

@implementation RTErrorFactory

+ (RTError *)loginErrorWithCode:(RTLoginErrors)code {
    return [RTError errorWithDomain:RTLoginErrorDomain
                               code:code
                           userInfo:nil
                      originalError:nil];
}

+ (RTError *)keyChainErrorWithCode:(RTKeyChainErrors)code
                     originalError:(NSError *)error {
    return [RTError errorWithDomain:RTKeyChainWrapperErrorDomain
                               code:code
                           userInfo:nil
                      originalError:error];
}

@end
