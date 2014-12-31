#import "RTOAuth2TokenError.h"

@interface RTOAuth2TokenError (ClientTokenErrorConverter)

- (NSError *)convertToClientTokenError;

@end

