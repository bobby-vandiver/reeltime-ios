#import <Foundation/Foundation.h>
#import "RTLoginErrors.h"

@interface NSError (RTErrorFactory)

+ (NSError *)rt_loginErrorWithCode:(RTLoginErrors)code;

@end