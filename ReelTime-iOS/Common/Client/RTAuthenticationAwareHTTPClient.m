#import "RTAuthenticationAwareHTTPClient.h"

#import "RTClientDelegate.h"

#import <RestKit/RestKit.h>
#import "RKObjectManager+IncludeHeaders.h"

static NSString *const AUTHORIZATION_HEADER = @"Authorization";

@interface RTAuthenticationAwareHTTPClient ()

@property RTClientDelegate *delegate;
@property RKObjectManager *objectManager;

@end

@implementation RTAuthenticationAwareHTTPClient

- (instancetype)initWithDelegate:(RTClientDelegate *)delegate
            restKitObjectManager:(RKObjectManager *)objectManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.objectManager = objectManager;
    }
    return self;
}

- (void)authenticatedGetForPath:(NSString *)path
                 withParameters:(NSDictionary *)parameters
                        success:(void (^)(id result))success
                        failure:(void (^)(id error))failure {
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self getForPath:path withParameters:parameters headers:headers success:success failure:failure];
}

- (void)unauthenticatedGetForPath:(NSString *)path
                   withParameters:(NSDictionary *)parameters
                          success:(void (^)(id result))success
                          failure:(void (^)(id error))failure {
    [self getForPath:path withParameters:parameters headers:nil success:success failure:failure];
}

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                         success:(void (^)(id result))success
                         failure:(void (^)(id error))failure {
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self postForPath:path withParameters:parameters headers:headers success:success failure:failure];
}

- (void)unauthenticatedPostForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(void (^)(id result))success
                           failure:(void (^)(id error))failure {
    [self postForPath:path withParameters:parameters headers:nil success:success failure:failure];
}

- (void)authenticatedDeleteForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(void (^)(id result))success
                           failure:(void (^)(id error))failure {
    NSDictionary *headers = @{AUTHORIZATION_HEADER:[self formatAccessTokenForAuthorizationHeader]};
    [self deleteForPath:path withParameters:parameters headers:headers success:success failure:failure];
}

- (void)getForPath:(NSString *)path
    withParameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(void (^)(id result))success
           failure:(void (^)(id error))failure {
    
    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers) {
        [self.objectManager getObject:nil
                                 path:path
                           parameters:parameters
                              headers:headers
                              success:successCallback
                              failure:failureCallback];
    }
    else {
        [self.objectManager getObject:nil
                                 path:path
                           parameters:parameters
                              success:successCallback
                              failure:failureCallback];
    }
}

- (void)postForPath:(NSString *)path
     withParameters:(NSDictionary *)parameters
            headers:(NSDictionary *)headers
            success:(void (^)(id result))success
            failure:(void (^)(id error))failure {
    
    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers) {
        [self.objectManager postObject:nil
                                  path:path
                            parameters:parameters
                               headers:headers
                               success:successCallback
                               failure:failureCallback];
    }
    else {
        [self.objectManager postObject:nil
                                  path:path
                            parameters:parameters
                               success:successCallback
                               failure:failureCallback];
    }
}

- (void)deleteForPath:(NSString *)path
       withParameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
              success:(void (^)(id result))success
              failure:(void (^)(id error))failure {
    
    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers) {
        [self.objectManager deleteObject:nil
                                    path:path
                              parameters:parameters
                                 headers:headers
                                 success:successCallback
                                 failure:failureCallback];
    }
    else {
        [self.objectManager deleteObject:nil
                                    path:path
                              parameters:parameters
                                 success:successCallback
                                 failure:failureCallback];
    }
}

- (NSString *)formatAccessTokenForAuthorizationHeader {
    NSString *token = [self.delegate accessTokenForCurrentUser];
    return [NSString stringWithFormat:@"Bearer %@", token];
}

- (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))successHandlerWithCallback:(void (^)(id))callback {
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        id result = [mappingResult firstObject];
        callback(result);
    };
}

- (void (^)(RKObjectRequestOperation *, NSError *))serverFailureHandlerWithCallback:(void (^)(id))callback {
    return ^(RKObjectRequestOperation *operation, NSError *error) {
        id errors = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        callback(errors);
    };
}

@end
