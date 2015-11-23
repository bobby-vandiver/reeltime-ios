#import "RTRemoveAccountServerErrorMapping.h"
#import "RTRemoveAccountError.h"

@implementation RTRemoveAccountServerErrorMapping

- (NSString *)errorDomain {
    return RTRemoveAccountErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Unauthorized operation requested": @(RTRemoveAccountErrorUnauthorized)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTRemoveAccountErrorUnknownError;
}

@end
