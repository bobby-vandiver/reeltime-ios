#import <Foundation/Foundation.h>

#import "RTLoginError.h"
#import "RTAccountRegistrationError.h"
#import "RTKeyChainError.h"

@interface RTErrorFactory : NSObject

+ (NSError *)loginErrorWithCode:(RTLoginError)code;

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error;

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationError)code;

+ (NSError *)keyChainErrorWithCode:(RTKeyChainError)code
                     originalError:(NSError *)error;

@end
