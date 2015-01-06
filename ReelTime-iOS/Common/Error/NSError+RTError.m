#import "NSError+RTError.h"

@implementation NSError (RTError)

+ (NSError *)errorWithDomain:(NSString *)domain
                        code:(NSInteger)code
                    userInfo:(NSDictionary *)dict
               originalError:(NSError *)error {
    return [[NSError alloc] initWithDomain:domain
                                      code:code
                                  userInfo:dict
                             originalError:error];
}

- (instancetype)initWithDomain:(NSString *)domain
                          code:(NSInteger)code
                      userInfo:(NSDictionary *)dict
                 originalError:(NSError *)error {
    NSMutableDictionary *userInfo = [dict mutableCopy];
    
    if (error) {
        if (!userInfo) {
            userInfo = [[NSMutableDictionary alloc] init];
        }
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
    }
    
    return [self initWithDomain:domain
                            code:code
                        userInfo:userInfo];
}

- (NSError *)underlyingError {
    return [self.userInfo objectForKey:NSUnderlyingErrorKey];
}

@end
