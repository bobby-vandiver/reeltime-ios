#import "RTRemoveVideoFromReelErrorCodeToErrorMessageMapping.h"
#import "RTRemoveVideoFromReelError.h"

@implementation RTRemoveVideoFromReelErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTRemoveVideoFromReelErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTRemoveVideoFromReelErrorVideoNotFound): @"Cannot remove an unknown video!",
             @(RTRemoveVideoFromReelErrorReelNotFound): @"Cannot remove video from an unknown reel!",
             @(RTRemoveVideoFromReelErrorUnauthorized): @"You do not have permission for that operation.",
             @(RTRemoveVideoFromReelErrorUnknownError): @"Unknown error occurred while removing video from reel. Please try again."
             };
}

@end
