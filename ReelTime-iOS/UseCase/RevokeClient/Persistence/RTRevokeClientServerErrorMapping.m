#import "RTRevokeClientServerErrorMapping.h"
#import "RTRevokeClientError.h"

@implementation RTRevokeClientServerErrorMapping

- (NSString *)errorDomain {
    return RTRevokeClientErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"[client_id] is required": @(RTRevokeClientErrorMissingClientId)
             };
}

@end
