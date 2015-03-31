#import "RTEndpointPathFormatter.h"

@implementation RTEndpointPathFormatter

- (NSString *)formatPath:(NSString *)path
            withClientId:(NSString *)clientId {
    return [self formatPath:path withParameters:@{@":client_id": clientId}];
}

- (NSString *)formatPath:(NSString *)path
         withAccessToken:(NSString *)accessToken {
    return [self formatPath:path withParameters:@{@":access_token": accessToken}];
}

- (NSString *)formatPath:(NSString *)path
            withUsername:(NSString *)username {
    return [self formatPath:path withParameters:@{@":username": username}];
}

- (NSString *)formatPath:(NSString *)path
              withReelId:(NSUInteger)reelId {
    return [self formatPath:path withParameters:@{@":reel_id": @(reelId)}];
}

- (NSString *)formatPath:(NSString *)path
             withVideoId:(NSUInteger)videoId {
    return [self formatPath:path withParameters:@{@":video_id": @(videoId)}];
}

- (NSString *)formatPath:(NSString *)path
              withReelId:(NSUInteger)reelId
                 videoId:(NSUInteger)videoId {
    NSDictionary *parameters = @{@":reel_id": @(reelId), @":video_id": @(videoId)};
    return [self formatPath:path withParameters:parameters];
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
