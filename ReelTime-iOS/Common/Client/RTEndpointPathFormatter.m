#import "RTEndpointPathFormatter.h"

@implementation RTEndpointPathFormatter

- (NSString *)formatPath:(NSString *)path
          withParameters:(NSDictionary *)parameters {
    NSString *formattedPath = [path copy];
    
    for (NSString *key in [parameters allKeys]) {
        NSString *value = [NSString stringWithFormat:@"%@", parameters[key]];
        formattedPath = [formattedPath stringByReplacingOccurrencesOfString:key withString:value];
    }
    
    return formattedPath;
}

@end
