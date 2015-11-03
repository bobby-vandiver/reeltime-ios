#import "RTUploadVideoServerErrorMapping.h"
#import "RTUploadVideoError.h"

@implementation RTUploadVideoServerErrorMapping

- (NSString *)errorDomain {
    return RTUploadVideoErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTUploadVideoErrorUnknownError;
}


@end
