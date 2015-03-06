#import "RTEndpointPathFormatter.h"

@implementation RTEndpointPathFormatter

- (NSString *)formatPath:(NSString *)path
            withClientId:(NSString *)clientId {
    return [self formatPath:path withParameters:@{@":client_id": clientId}];
}

- (NSString *)formatPath:(NSString *)path
              withReelId:(NSUInteger)reelId {
    return [self formatPath:path withParameters:@{@":reel_id": @(reelId)}];
}

- (NSString *)formatPath:(NSString *)path
            withUsername:(NSString *)username {
    return [self formatPath:path withParameters:@{@":username": username}];
}

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
