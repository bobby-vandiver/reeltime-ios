#import "RTFollowUserErrorCodeToErrorMessageMapping.h"
#import "RTFollowUserError.h"

@implementation RTFollowUserErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTFollowUserErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTFollowUserErrorUserNotFound): @"Cannot follow an unknown user!",
             @(RTFollowUserErrorUnknownError): @"Unknown error occurred while following user. Please try again."
             };
}

@end
