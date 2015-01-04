#import <Foundation/Foundation.h>

#import "RTError.h"

#import "RTLoginErrors.h"
#import "RTKeyChainErrors.h"

@interface RTErrorFactory : NSObject

+ (RTError *)loginErrorWithCode:(RTLoginErrors)code;

+ (RTError *)keyChainErrorWithCode:(RTKeyChainErrors)code
                     originalError:(NSError *)error;
@end
