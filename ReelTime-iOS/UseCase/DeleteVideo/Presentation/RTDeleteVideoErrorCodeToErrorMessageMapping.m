#import "RTDeleteVideoErrorCodeToErrorMessageMapping.h"
#import "RTDeleteVideoError.h"

@implementation RTDeleteVideoErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTDeleteVideoErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTDeleteVideoErrorVideoNotFound): @"Cannot delete an unknown video!",
             @(RTDeleteVideoErrorUnauthorized): @"You do not have permission for that operation.",
             @(RTDeleteVideoErrorUnknownError): @"Unknown error occurred while deleting video. Please try again."
             };
}

@end
