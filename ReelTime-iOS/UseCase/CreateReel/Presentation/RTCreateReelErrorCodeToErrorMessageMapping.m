#import "RTCreateReelErrorCodeToErrorMessageMapping.h"
#import "RTCreateReelError.h"

@implementation RTCreateReelErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTCreateReelErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTCreateReelErrorMissingReelName): @"Reel name is required",
             @(RTCreateReelErrorInvalidReelName): @"Reel name must be 3 to 25 characters",
             @(RTCreateReelErrorReservedReelName): @"Reel name is reserved",
             @(RTCreateReelErrorReelNameIsUnavailable): @"Reel name is unavailable",
             @(RTCreateReelErrorUnknownError): @"Unknown error occurred while creating reel. Please try again."
             };
}

@end
