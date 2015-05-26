#import "RTChangeDisplayNameServerErrorMapping.h"
#import "RTChangeDisplayNameError.h"

@implementation RTChangeDisplayNameServerErrorMapping

- (NSString *)errorDomain {
    return RTChangeDisplayNameErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"[new_display_name] is required": @(RTChangeDisplayNameErrorMissingDisplayName),
             @"[new_display_name] must be 2-20 alphanumeric or space characters long": @(RTChangeDisplayNameErrorInvalidDisplayName)
             };
}

@end
