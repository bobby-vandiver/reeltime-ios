#import "RTRemoveAccountErrorCodeToErrorMessageMapping.h"
#import "RTRemoveAccountError.h"

@implementation RTRemoveAccountErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTRemoveAccountErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTRemoveAccountErrorUnauthorized): @"You are not authorized to remove this account!",
             @(RTRemoveAccountErrorUnknownError): @"Unknown error occurred while removing account. Please try again."
             };
}

@end
