#import "RTDeleteVideoServerErrorMapping.h"
#import "RTDeleteVideoError.h"

@implementation RTDeleteVideoServerErrorMapping

- (NSString *)errorDomain {
    return RTDeleteVideoErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested video was not found": @(RTDeleteVideoErrorVideoNotFound),
             @"Unauthorized operation requested": @(RTDeleteVideoErrorUnauthorized)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTDeleteVideoErrorUnknownError;
}

@end
