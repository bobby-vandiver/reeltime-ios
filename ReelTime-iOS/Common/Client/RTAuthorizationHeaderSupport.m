#import "RTAuthorizationHeaderSupport.h"

NSString *const RTAuthorizationHeader = @"Authorization";

@implementation RTAuthorizationHeaderSupport

- (NSString *)bearerTokenHeaderFromAccessToken:(NSString *)accessToken {
    return [NSString stringWithFormat:@"Bearer %@", accessToken];
}

@end
