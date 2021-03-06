#import <Foundation/Foundation.h>

extern NSString *const GET;
extern NSString *const POST;
extern NSString *const DELETE;

extern NSString *const ACCESS_TOKEN;
extern NSString *const BEARER_TOKEN_AUTHORIZATION_HEADER;

@interface RTClientSpecHelper : NSObject

- (NSString *)stringForUnsignedInteger:(NSUInteger)unsignedInteger;

- (NSRegularExpression *)createUrlRegexForEndpoint:(NSString *)endpoint;

- (NSRegularExpression *)createUrlRegexForEndpoint:(NSString *)endpoint
                                    withParameters:(NSDictionary *)parameters;

- (NSData *)rawDataFromFile:(NSString *)filename
                     ofType:(NSString *)type;

- (void)stubUnauthenticatedRequestWithMethod:(NSString *)method
                                    urlRegex:(NSRegularExpression *)urlRegex
                         rawResponseFilename:(NSString *)rawResponseFilename;

- (void)stubAuthenticatedRequestWithMethod:(NSString *)method
                                  urlRegex:(NSRegularExpression *)urlRegex
                       rawResponseFilename:(NSString *)rawResponseFilename;

@end
