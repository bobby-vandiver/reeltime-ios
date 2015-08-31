#import "RTCreateReelServerErrorMapping.h"
#import "RTCreateReelError.h"

@implementation RTCreateReelServerErrorMapping

- (NSString *)errorDomain {
    return RTCreateReelErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"[name] is required": @(RTCreateReelErrorMissingReelName),
             @"[name] must be at least 5 characters long": @(RTCreateReelErrorInvalidReelName),
             @"[name] must be no more than 25 characters long": @(RTCreateReelErrorInvalidReelName),
             @"[name] is reserved": @(RTCreateReelErrorReservedReelName),
             @"Requested reel name is not allowed": @(RTCreateReelErrorReelNameIsUnavailable)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTCreateReelErrorUnknownError;
}

@end
