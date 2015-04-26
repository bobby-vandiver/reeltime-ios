#import <Foundation/Foundation.h>

#import "RTAccountRegistrationError.h"
#import "RTDeviceRegistrationError.h"
#import "RTKeyChainError.h"
#import "RTLoginError.h"
#import "RTPagedListError.h"
#import "RTUserSummaryError.h"

@interface RTErrorFactory : NSObject

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationError)code;

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code;

+ (NSError *)keyChainErrorWithCode:(RTKeyChainError)code
                     originalError:(NSError *)error;

+ (NSError *)loginErrorWithCode:(RTLoginError)code;

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error;

+ (NSError *)pagedListErrorWithCode:(RTPagedListError)code;

+ (NSError *)userSummaryErrorWithCode:(RTUserSummaryError)code;

@end
