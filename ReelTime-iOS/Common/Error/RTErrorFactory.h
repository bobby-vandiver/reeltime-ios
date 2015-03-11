#import <Foundation/Foundation.h>

#import "RTKeyChainError.h"
#import "RTLoginError.h"
#import "RTAccountRegistrationError.h"
#import "RTPagedListError.h"

@interface RTErrorFactory : NSObject

+ (NSError *)keyChainErrorWithCode:(RTKeyChainError)code
                     originalError:(NSError *)error;

+ (NSError *)loginErrorWithCode:(RTLoginError)code;

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error;

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationError)code;

+ (NSError *)pagedListErrorWithCode:(RTPagedListError)code;

@end
