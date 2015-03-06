#import "RTClientSpecHelper.h"
#import <Nocilla/Nocilla.h>

NSString *const GET = @"GET";
NSString *const POST = @"POST";
NSString *const DELETE = @"DELETE";

NSString *const AUTHORIZATION = @"Authorization";

NSString *const ACCESS_TOKEN = @"access-token";
NSString *const BEARER_TOKEN_AUTHORIZATION_HEADER = @"Bearer access-token";

@implementation RTClientSpecHelper

- (NSString *)stringForUnsignedInteger:(NSUInteger)unsignedInteger {
    return [NSString stringWithFormat:@"%lu", (unsigned long)unsignedInteger];
}

- (NSRegularExpression *)createUrlRegexForEndpoint:(NSString *)endpoint {
    return [NSString stringWithFormat:@"http://(.*?)/%@", endpoint].regex;
}

- (NSRegularExpression *)createUrlRegexForEndpoint:(NSString *)endpoint
                                    withParameters:(NSDictionary *)parameters {
    NSString *populatedEndpoint = [endpoint copy];
    
    for(NSString *key in [parameters allKeys]) {
        NSString *value = parameters[key];
        populatedEndpoint = [populatedEndpoint stringByReplacingOccurrencesOfString:key withString:value];
    }
    
    return [self createUrlRegexForEndpoint:populatedEndpoint];
}

- (NSData *)rawResponseFromFile:(NSString *)filename {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:filename ofType:@"txt"];
    return [NSData dataWithContentsOfFile:path];
}

- (void)stubUnauthenticatedRequestWithMethod:(NSString *)method
                                    urlRegex:(NSRegularExpression *)urlRegex
                         rawResponseFilename:(NSString *)rawResponseFilename {
    stubRequest(method, urlRegex).
    andReturnRawResponse([self rawResponseFromFile:rawResponseFilename]);
}

- (void)stubAuthenticatedRequestWithMethod:(NSString *)method
                                  urlRegex:(NSRegularExpression *)urlRegex
                       rawResponseFilename:(NSString *)rawResponseFilename {
    stubRequest(method, urlRegex).
    withHeader(AUTHORIZATION, BEARER_TOKEN_AUTHORIZATION_HEADER).
    andReturnRawResponse([self rawResponseFromFile:rawResponseFilename]);
}

@end
