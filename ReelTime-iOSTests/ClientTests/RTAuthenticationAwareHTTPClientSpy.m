#import "RTAuthenticationAwareHTTPClientSpy.h"

@interface RTAuthenticationAwareHTTPClientSpy ()

@property (readwrite) NSString *lastPath;
@property (readwrite) NSDictionary *lastParameters;

@end

@implementation RTAuthenticationAwareHTTPClientSpy

- (void)authenticatedGetForPath:(NSString *)path
                 withParameters:(NSDictionary *)parameters
                        success:(SuccessCallback)success
                        failure:(FailureCallback)failure {
    [self rememberPath:path parameters:parameters];
    [super authenticatedGetForPath:path withParameters:parameters success:success failure:failure];
}

- (void)unauthenticatedGetForPath:(NSString *)path
                   withParameters:(NSDictionary *)parameters
                          success:(SuccessCallback)success
                          failure:(FailureCallback)failure {
    [self rememberPath:path parameters:parameters];
    [super unauthenticatedGetForPath:path withParameters:parameters success:success failure:failure];
}

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                         success:(SuccessCallback)success
                         failure:(FailureCallback)failure {
    [self rememberPath:path parameters:parameters];
    [super authenticatedPostForPath:path withParameters:parameters success:success failure:failure];
}

- (void)unauthenticatedPostForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(SuccessCallback)success
                           failure:(FailureCallback)failure {
    [self rememberPath:path parameters:parameters];
    [super unauthenticatedPostForPath:path withParameters:parameters success:success failure:failure];
}

- (void)authenticatedDeleteForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(SuccessCallback)success
                           failure:(FailureCallback)failure {
    [self rememberPath:path parameters:parameters];
    [super authenticatedDeleteForPath:path withParameters:parameters success:success failure:failure];
}

- (void)rememberPath:(NSString *)path
          parameters:(NSDictionary *)parameters {
    self.lastPath = path;
    self.lastParameters = parameters;
}

@end
