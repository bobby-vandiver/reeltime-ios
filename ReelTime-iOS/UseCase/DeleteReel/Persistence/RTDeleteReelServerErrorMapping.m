#import "RTDeleteReelServerErrorMapping.h"
#import "RTDeleteReelError.h"

@implementation RTDeleteReelServerErrorMapping

- (NSString *)errorDomain {
    return RTDeleteReelErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested reel was not found": @(RTDeleteReelErrorReelNotFound),
             @"Unauthorized operation requested": @(RTDeleteReelErrorUnauthorized)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTDeleteReelErrorUnknownError;
}

@end
