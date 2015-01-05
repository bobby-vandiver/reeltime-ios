#import "RTOAuth2TokenError.h"
#import "RTError.h"

@interface RTOAuth2TokenError (RTClientTokenErrorConverter)

- (RTError *)convertToClientTokenError;

@end

