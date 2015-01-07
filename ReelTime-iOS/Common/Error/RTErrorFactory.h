#import <Foundation/Foundation.h>

#import "RTLoginErrors.h"
#import "RTKeyChainErrors.h"
#import "RTClientErrors.h"

@interface RTErrorFactory : NSObject

+ (NSError *)loginErrorWithCode:(RTLoginErrors)code;

+ (NSError *)loginErrorWithCode:(RTLoginErrors)code
                  originalError:(NSError *)error;

+ (NSError *)keyChainErrorWithCode:(RTKeyChainErrors)code
                     originalError:(NSError *)error;

+ (NSError *)clientTokenErrorWithCode:(RTClientTokenErrors)code;

@end
