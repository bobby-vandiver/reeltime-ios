#import "RTDeleteVideoErrorCodeToErrorMessageMapping.h"
#import "RTDeleteVideoError.h"

@implementation RTDeleteVideoErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTDeleteVideoErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTDeleteVideoErrorVideoNotFound): @"Cannot delete an unknown video!",
             @(RTDeleteVideoErrorUnknownError): @"Unknown error occurred while deleting video. Please try again."
             };
}

@end
