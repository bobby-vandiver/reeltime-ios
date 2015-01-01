#import "RTOAuth2TokenError+RTClientTokenErrorConverter.h"
#import "RTClientErrors.h"

@implementation RTOAuth2TokenError (ClientTokenErrorConverter)

- (NSError *)convertToClientTokenError {
    NSString *errorCode = self.errorCode;
    
    RTClientTokenErrors clientTokenErrorsCode;
    
    if ([errorCode isEqualToString:@"invalid_client"]) {
        clientTokenErrorsCode = InvalidClientCredentials;
    }
    
    return [NSError errorWithDomain:RTClientTokenErrorDomain
                               code:clientTokenErrorsCode
                           userInfo:nil];
}

@end

