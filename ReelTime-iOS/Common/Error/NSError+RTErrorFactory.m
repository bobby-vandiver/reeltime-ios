#import "NSError+RTErrorFactory.h"

@implementation NSError (RTErrorFactory)

+ (NSError *)rt_loginErrorWithCode:(RTLoginErrors)code {
    return [NSError errorWithDomain:RTLoginErrorDomain
                               code:code
                           userInfo:nil];
}

@end