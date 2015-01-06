#import <Foundation/Foundation.h>

#import "RTOAuth2TokenError.h"

@interface RTOAuth2TokenError (RTClientTokenErrorConverter)

- (NSError *)convertToClientTokenError;

@end

