#import <Foundation/Foundation.h>

extern NSString *const RTAuthorizationHeader;

@interface RTAuthorizationHeaderSupport : NSObject

- (NSString *)bearerTokenHeaderFromAccessToken:(NSString *)accessToken;

@end
