#import "RTClientAdditionalConfiguration.h"
#import <RestKit/RestKit.h>

@implementation RTClientAdditionalConfiguration

+ (void)registerEmptyResponseSupport {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    });
}

@end
