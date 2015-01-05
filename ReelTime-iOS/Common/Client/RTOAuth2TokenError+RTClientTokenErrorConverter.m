#import "RTOAuth2TokenError+RTClientTokenErrorConverter.h"
#import "RTErrorFactory.h"

@implementation RTOAuth2TokenError (ClientTokenErrorConverter)

- (RTError *)convertToClientTokenError {
    NSString *errorCode = self.errorCode;
    
    RTClientTokenErrors clientTokenErrorsCode;
    
    if ([errorCode isEqualToString:@"invalid_client"]) {
        clientTokenErrorsCode = InvalidClientCredentials;
    }
    
    return [RTErrorFactory clientTokenErrorWithCode:clientTokenErrorsCode];
}

@end

