#import "RTError.h"

@interface RTError ()

@property (readwrite) NSError *originalError;

@end

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
    self = [super initWithDomain:domain
                            code:code
                        userInfo:dict];
    if (self) {
        self.originalError = error;
    }
    return self;
}

@end
