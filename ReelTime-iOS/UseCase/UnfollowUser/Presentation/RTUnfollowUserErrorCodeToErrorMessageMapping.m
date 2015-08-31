#import "RTUnfollowUserErrorCodeToErrorMessageMapping.h"
#import "RTUnfollowUserError.h"

@implementation RTUnfollowUserErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTUnfollowUserErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTUnfollowUserErrorUserNotFound): @"Cannot unfollow an unknown user!",
             @(RTUnfollowUserErrorUnknownError): @"Unknown error occurred while following user. Please try again."
             };
}

@end
