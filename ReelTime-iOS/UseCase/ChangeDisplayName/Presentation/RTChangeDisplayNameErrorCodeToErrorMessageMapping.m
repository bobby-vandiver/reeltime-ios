#import "RTChangeDisplayNameErrorCodeToErrorMessageMapping.h"
#import "RTChangeDisplayNameError.h"

@implementation RTChangeDisplayNameErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTChangeDisplayNameErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTChangeDisplayNameErrorMissingDisplayName): @"Display name is required",
             @(RTChangeDisplayNameErrorInvalidDisplayName): @"Display name must be 2-20 alphanumeric or space characters"
             };
}

@end
