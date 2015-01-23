#import "RTOAuth2TokenError+RTClientTokenErrorConverter.h"
#import "RTErrorFactory.h"

@implementation RTOAuth2TokenError (ClientTokenErrorConverter)

- (NSError *)convertToClientTokenError {
    NSString *errorCode = self.errorCode;
    
    RTClientTokenErrors clientTokenErrorsCode;
    
    if ([errorCode isEqualToString:@"invalid_client"]) {
        clientTokenErrorsCode = InvalidClientCredentials;
    }
    else if ([errorCode isEqualToString:@"invalid_grant"]) {
        clientTokenErrorsCode = InvalidUserCredentials;
    }
    else {
        clientTokenErrorsCode = UnknownTokenError;
    }
    
    return [RTErrorFactory clientTokenErrorWithCode:clientTokenErrorsCode];
}

@end

