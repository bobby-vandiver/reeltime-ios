#import "RTAuthenticationAwareHTTPClient.h"

@interface RTAuthenticationAwareHTTPClientSpy : RTAuthenticationAwareHTTPClient

@property (readonly) NSString *lastPath;
@property (readonly) NSDictionary *lastParameters;

@end
