#import "RTClientAdditionalConfiguration.h"
#import "RTImagePNGSerialization.h"

#import <RestKit/RestKit.h>

@implementation RTClientAdditionalConfiguration

+ (void)registerEmptyResponseSupport {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    });
}

+ (void)registerPNGResponseSupport {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [RKMIMETypeSerialization registerClass:[RTImagePNGSerialization class] forMIMEType:@"image/png"];
    });
}

@end
