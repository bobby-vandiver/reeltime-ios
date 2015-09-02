#import "RTDeleteReelErrorCodeToErrorMessageMapping.h"
#import "RTDeleteReelError.h"

@implementation RTDeleteReelErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTDeleteReelErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTDeleteReelErrorReelNotFound): @"Cannot delete an unknown reel!",
             @(RTDeleteReelErrorUnauthorized): @"You do not have permission for that operation.",
             @(RTDeleteReelErrorUnknownError): @"Unknown error occurred while deleting reel. Please try again."
             };
}

@end
