#import "RTFollowUserServerErrorMapping.h"
#import "RTFollowUserError.h"

@implementation RTFollowUserServerErrorMapping

- (NSString *)errorDomain {
    return RTFollowUserErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested user was not found": @(RTFollowUserErrorUserNotFound)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTFollowUserErrorUnknownError;
}

@end
