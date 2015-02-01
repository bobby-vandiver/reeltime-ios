#import <Foundation/Foundation.h>

#import "RTLoginError.h"
#import "RTKeyChainErrors.h"

@interface NSError (RTError)

+ (NSError *)errorWithDomain:(NSString *)domain
                        code:(NSInteger)code
                    userInfo:(NSDictionary *)dict
               originalError:(NSError *)error;

- (instancetype)initWithDomain:(NSString *)domain
                          code:(NSInteger)code
                      userInfo:(NSDictionary *)dict
                 originalError:(NSError *)error;

- (NSError *)underlyingError;

@end
