#import <Foundation/Foundation.h>

#import "RTLoginError.h"
#import "RTAccountRegistrationErrors.h"
#import "RTKeyChainErrors.h"

@interface RTErrorFactory : NSObject

+ (NSError *)loginErrorWithCode:(RTLoginError)code;

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error;

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationErrors)code;

+ (NSError *)keyChainErrorWithCode:(RTKeyChainErrors)code
                     originalError:(NSError *)error;

@end
