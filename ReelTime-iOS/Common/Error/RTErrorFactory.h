#import <Foundation/Foundation.h>

#import "RTLoginErrors.h"
#import "RTAccountRegistrationErrors.h"
#import "RTKeyChainErrors.h"

@interface RTErrorFactory : NSObject

+ (NSError *)loginErrorWithCode:(RTLoginErrors)code;

+ (NSError *)loginErrorWithCode:(RTLoginErrors)code
                  originalError:(NSError *)error;

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationErrors)code;

+ (NSError *)keyChainErrorWithCode:(RTKeyChainErrors)code
                     originalError:(NSError *)error;

@end
