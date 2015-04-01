#import "RTImagePNGSerialization.h"

@implementation RTImagePNGSerialization

+ (id)objectFromData:(NSData *)data
               error:(NSError *__autoreleasing *)error {
    return data;
}

+ (id)dataFromObject:(NSData *)data
               error:(NSError *__autoreleasing *)error {
    return data;
}

@end
