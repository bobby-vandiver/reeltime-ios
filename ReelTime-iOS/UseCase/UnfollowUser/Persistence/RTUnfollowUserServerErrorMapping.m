#import "RTUnfollowUserServerErrorMapping.h"
#import "RTUnfollowUserError.h"

@implementation RTUnfollowUserServerErrorMapping

- (NSString *)errorDomain {
    return RTUnfollowUserErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested user was not found": @(RTUnfollowUserErrorUserNotFound)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTUnfollowUserErrorUnknownError;
}

@end
