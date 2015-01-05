#import "RTError.h"

@implementation RTError

+ (RTError *)errorWithDomain:(NSString *)domain
                        code:(NSInteger)code
                    userInfo:(NSDictionary *)dict
               originalError:(NSError *)error {
    return [[RTError alloc] initWithDomain:domain
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
    
    return [super initWithDomain:domain
                            code:code
                        userInfo:userInfo];
}

- (NSError *)originalError {
    return [self.userInfo objectForKey:NSUnderlyingErrorKey];
}

@end
